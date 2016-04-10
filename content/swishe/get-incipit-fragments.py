#!/usr/bin/python

import string, re, os
from xml.sax import *

FULL_REPOSITORY = "../repository/repository.xml"
REPOS_PATH = "../repository/"

INCIPIT_TEMPLATE = """<html>
<head>
<title>%(title)s</title>
<META NAME="id" CONTENT="%(id)s">
<META NAME="type" CONTENT="%(type)s">
</head>
<body>
%(content)s
</body>
</html>"""

SWISHE_TEMPLATE = """Path-Name: %(Path-Name)s
Content-Length: %(Content-Length)s
Document-Type: HTML*

%(Document)s"""

CURSUS_REF = "/ed/%s"

full_type = {"ant": "Antiphon", "res": "Respond", "prayer": "Prayer"}

INCIPITS_FN_LIST = []

incipit_fn_re = re.compile("[co][0-9]{4}\.xml")

for p, d, f in os.walk(REPOS_PATH):
    INCIPITS_FN_LIST += [fn for fn in f if incipit_fn_re.match(fn)]

_space_re = re.compile("\s+", re.MULTILINE)
def normalize_space(s):
    return _space_re.sub(" ", s.strip())

class generate_incipit_fragments(ContentHandler):
    def __init__(self, mode="full-repos"):
        self.c_inipit_id = ""
        self.c_incipit = {"id": "", "type": "", "content": ""}

        self.collect_chars = False
        self.chars_buffer = ""

        if mode == "full-repos":
            parse(FULL_REPOSITORY, self)
        elif mode == "burst-repos":
            for fn in INCIPITS_FN_LIST:
                parse(REPOS_PATH + fn, self)

    def startElement(self, name, attrs):
        if name in ["ant", "res", "prayer"]:
            self.c_incipit_id = str(attrs['id'])
            self.c_incipit["id"] = str(attrs['id'])
            self.c_incipit["type"] = name

            self.collect_chars = True

    def characters(self, data):
        if self.collect_chars:
            self.chars_buffer += data

    def endElement(self, name):
        if name in ["ant", "res", "prayer"]:
            self.c_incipit["content"] = normalize_space(self.chars_buffer).encode('utf-8', 'ignore')
            if len(self.c_incipit["content"]) > 30:
                self.c_incipit["title"] = full_type[name] + ": " + self.c_incipit["content"][:30] + "..."
            else:
                self.c_incipit["title"] = full_type[name] + ": " + self.c_incipit["content"]

            self.collect_chars = False
            self.chars_buffer = ""

            content = INCIPIT_TEMPLATE % self.c_incipit
            print SWISHE_TEMPLATE % {"Path-Name": CURSUS_REF % self.c_incipit["id"],\
                                     "Content-Length": len(content)+1,\
                                     "Document": content}  # content length is +1 because print adds an extra nl

def main():
    generate_incipit_fragments("burst-repos")

if __name__ == "__main__":
    main()
