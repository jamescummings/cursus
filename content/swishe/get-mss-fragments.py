#!/usr/bin/python

import string, re, os
#from xml.sax import *
from xml.parsers import expat
import lxml.etree

MSS_INDEX = "../mss/mss.xml"
MSS_PATH = "../mss/"
FEASTS_FILE = "../cantus/feast.xml"
REPOS_PATH = "../repository/"
VULGATE_PATH = "../vulgate/"

SERVICE_TEMPLATE = """<html>
<head>
<title>%(title)s</title>
<META NAME="id" CONTENT="%(id)s">
<META NAME="ms-id" CONTENT="%(ms-id)s">
<META NAME="feast-code" CONTENT="%(feast-code)s">
<META NAME="day-num" CONTENT="%(day-num)s">
<META NAME="service-name" CONTENT="%(name)s">
</head>
<body>
%(content)s
</body>
</html>"""

SWISHE_TEMPLATE = """Path-Name: %(Path-Name)s
Content-Length: %(Content-Length)s
Document-Type: HTML*

%(Document)s"""

CURSUS_REF = "/ms/%s#%s"

_corrections = {"Corinthians1": "1Corinthians",
                "Corinthians2": "2Corinthians",
                "Thessalonians1": "1Thessalonians",
                "Psalmsg": "PsalmsG",
                "Psalmsh": "PsalmsH"}

def CORRECT_VULGATE_HREF(href):
    if href in _corrections.keys():
        return _corrections[href]
    else:
        return href

KNOWN_MALFORMED_ID_REFS = ["ID(c)", "ID($)", "ID(xxxxxx)", "ID(o)"]

INCIPITS_FN_LIST = []

incipit_fn_re = re.compile("[co][0-9]{4}\.xml")

for p, d, f in os.walk(REPOS_PATH):
    INCIPITS_FN_LIST += [fn for fn in f if incipit_fn_re.match(fn)]

_space_re = re.compile("\s+", re.MULTILINE)
def normalize_space(s):
    return _space_re.sub(" ", s.strip())

incipit_id_re = re.compile(".*([co][0-9]{4}).*")
bib_id_re = re.compile("B\.(\w+)\.([0-9]{3})\.([0-9]{3})")
ccc_vvv_re = re.compile("([0-9]{3})\.([0-9]{3})")
all_ccc_vvv_re = re.compile(".*([0-9]{3}\.[0-9]{3}).*")

from StringIO import StringIO

INCIPIT_TEXT_XSLT=lxml.etree.XSLT(lxml.etree.parse(StringIO("""<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:param name="body" /><xsl:param name="wit" />
<xsl:output method="text" />
<xsl:template match="/">
<xsl:apply-templates select="//*[name()=$body and contains(@wit, $wit)]" />
</xsl:template>
<xsl:template match="aBody|rBody|vBody|pBody">
<xsl:apply-templates />
</xsl:template>
<xsl:template match="rdg|rep">
<xsl:if test="contains(@wit, $wit)"><xsl:apply-templates /></xsl:if>
</xsl:template>
</xsl:stylesheet>""")))

def extract_incipit_text(doc, body, wit):
    return str(INCIPIT_TEXT_XSLT(doc, **{"body": "'%s'" % body, "wit": "'%s'" % wit}))

class generate_service_fragments:
    def __init__(self):
        self.c_service_id = ""
        self.c_service = {"id": "", "title": "", "ms-id": "", "feast-code": "", "day-num": "", "service-name": ""}

        self.collect_chars = False
        self.chars_buffer = ""

        self.collect_day_title = False
        self.c_day_title = ""
        self.collect_service_title = False
        self.c_service_title = ""

        mss_index = lxml.etree.parse(MSS_INDEX)

        for ms_fn in mss_index.xpath("//witness[@filename!='none']/@filename"):
            self.c_file_name = ms_fn.replace(".xml", "")
            
            p = expat.ParserCreate()
            p.buffer_text = True
            p.StartElementHandler = self.startElement
            p.EndElementHandler = self.endElement
            p.CharacterDataHandler = self.characters

            ms = file(MSS_PATH + ms_fn, "r")
            p.ParseFile(ms)

            ms.close()
            del p

    def startElement(self, name, attrs):
        if name == "text":
            self.c_service["ms-id"] = str(attrs['n'])
            
        elif name == "Day":
            self.c_service["day-num"] = str(attrs['num'])
            self.c_service["feast-code"] = str(attrs['code'])

        elif name == "service":
            self.collect_chars = True
            self.c_service_id = "%s.%s-%s" % (self.c_service["ms-id"],\
                                              self.c_service["feast-code"],\
                                              str(attrs['name']))
            self.c_service["id"] = self.c_service_id
            self.c_service["name"] = str(attrs['name'])
            
        elif name == "rubric" and attrs.has_key('type') and attrs['type'] == "dayTitle":
            self.collect_day_title = True
            self.c_day_title = ""

        elif name == "rubric" and attrs.has_key('type') and attrs['type'] == "serviceTitle":
            self.collect_service_title = True
            self.c_service_title = ""

        elif name == "xptr" and not attrs.has_key('type'): pass

        elif name == "xptr" and attrs.has_key('type') and attrs['type'].upper() != "BIBLE":
            try:
                incipit_id = incipit_id_re.match(str(attrs['from'])).group(1)

                incipit_doc = lxml.etree.parse(REPOS_PATH + incipit_id + ".xml")

                incipit_text = extract_incipit_text(incipit_doc, str(attrs['type']), self.c_service["ms-id"])

                self.chars_buffer += incipit_text

            except AttributeError:
                if str(attrs['from']) not in KNOWN_MALFORMED_ID_REFS:
                    raise Exception("Invalid incipit id: MS: %s; feast: %s; service: %s; xptr type: %s; invalid 'from' attr: \"%s\"" %\
                                    (self.c_service["ms-id"], self.c_service["feast-code"], self.c_service["name"],\
                                     attrs['type'], attrs['from']))

        elif name == "xptr" and attrs.has_key('type') and attrs['type'].upper() == "BIBLE":
            href = CORRECT_VULGATE_HREF(attrs['href'])

            try:
                book_doc = lxml.etree.parse(VULGATE_PATH + href + ".xml")

                from_id = all_ccc_vvv_re.match(str(attrs['from'])).group(1)

                if attrs.has_key('to'):
                    to_id = all_ccc_vvv_re.match(str(attrs['to'])).group(1)

                    from_chap, from_verse = ccc_vvv_re.match(from_id).group(1,2)
                    to_chap, to_verse = ccc_vvv_re.match(to_id).group(1,2)

                    for chap_num in range(int(from_chap), int(to_chap)+1):
                        if from_chap != to_chap:
                            if chap_num == int(from_chap):
                                i_from_verse = int(from_verse)
                                last_verse = string.join(book_doc.xpath("//chapter[@num='%d']/verse[position()=last()]/@id" % chap_num))
                                i_to_verse = int(bib_id_re.match(last_verse).group(3))
                            elif chap_num < int(to_chap):
                                i_from_verse = 1
                                last_verse = string.join(book_doc.xpath("//chapter[@num='%d']/verse[position()=last()]/@id" % chap_num))
                                i_to_verse = int(bib_id_re.match(last_verse).group(3))
                            else:
                                i_from_verse = 1
                                i_to_verse = int(to_verse)
                        else:
                            i_from_verse = int(from_verse)
                            i_to_verse = int(to_verse)
                        
                        for verse_num in range(i_from_verse, i_to_verse+1):
                            verse_id = "B.%s.%s.%s" % (str(href), str(chap_num).zfill(3), str(verse_num).zfill(3))
                            self.chars_buffer += " " + string.join(book_doc.xpath("//verse[@id='%s']//l/text()" % verse_id))
                else:
                    self.chars_buffer += " " + string.join(book_doc.xpath("//verse[@id='%s']//l/text()" % from_id))
            
            except AttributeError:
                if str(attrs['from']) not in KNOWN_MALFORMED_ID_REFS:
                    raise Exception("Invalid bible ref id: MS: %s; feast: %s; service: %s; xptr href: %s; invalid 'from' attr: \"%s\"" %\
                                    (self.c_service["ms-id"], self.c_service["feast-code"], self.c_service["name"], href, attrs['from']))
            except IOError:
                raise Exception("Invalid bible href: MS: %s; feast: %s; service: %s; invalid xptr href: \"%s\"" %\
                                (self.c_service["ms-id"], self.c_service["feast-code"], self.c_service["name"], href))
            

    def characters(self, data):
        if self.collect_chars:
            self.chars_buffer += data
        if self.collect_day_title:
            self.c_day_title += data
        if self.collect_service_title:
            self.c_service_title += data

    def endElement(self, name):
        if name == "rubric" and self.collect_day_title:
            self.collect_day_title = False

        if name == "rubric" and self.collect_service_title:
            self.collect_service_title = False

        elif name == "service":
            self.c_service["title"] = normalize_space("%s: %s: %s" % (self.c_service["ms-id"], self.c_day_title, self.c_service_title)).encode('utf-8', 'ignore')
            self.c_service["content"] = normalize_space(self.chars_buffer).encode('utf-8', 'ignore')
            self.collect_chars = False
            self.chars_buffer = ""
            
            document = SERVICE_TEMPLATE % self.c_service
            print SWISHE_TEMPLATE % {"Path-Name": CURSUS_REF % (self.c_file_name, self.c_service["id"]),\
                                     "Content-Length": len(document)+1,\
                                     "Document": document}  # content length is +1 because print adds an extra nl

def main():
    generate_service_fragments()

if __name__ == "__main__":
    main()

