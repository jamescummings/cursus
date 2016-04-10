#!/usr/bin/python

from xml.sax import *

FULL_VULGATE = "../vulgate/full-vulgate.xml"

VERSE_TEMPLATE = """<html>
<head>
<title>%(title)s</title>
<META NAME="id" CONTENT="%(id)s">
<META NAME="book" CONTENT="%(book)s">
<META NAME="verse" CONTENT="%(verse)s">
</head>
<body>
%(content)s
</body>
</html>"""

SWISHE_TEMPLATE = """Path-Name: %(Path-Name)s
Content-Length: %(Content-Length)s
Document-Type: HTML*

%(Document)s"""

CURSUS_REF = "/vulgate/%s#%s"

verse_part = {"bookName": "book", "verseNum": "verse", "l": "content"}

class generate_vulgate_fragments(ContentHandler):
    def __init__(self):
        self.c_verse_id = ""
        self.c_verse = {"id": "", "title": "", "book": "", "verse": "", "content": ""}
        self.collect_chars = False
        self.chars_buffer = ""

        parse(FULL_VULGATE, self)

    def startElement(self, name, attrs):
        if name == "verse":
            self.c_verse_id = str(attrs['id'])
            self.c_verse["id"] = str(attrs['id'])

        elif name in ["bookName", "verseNum", "l"]:
            self.collect_chars = True
            self.chars_buffer = ""
            
    def characters(self, data):
        if self.collect_chars:
            self.chars_buffer += data

    def endElement(self, name):
        if name in ["bookName", "verseNum", "l"]:
            self.c_verse[verse_part[name]] = self.chars_buffer.encode('utf-8', 'ignore')
            self.chars_buffer = ""
            self.collect_chars = False

        elif name == "verse":
            self.c_verse["title"] = self.c_verse["book"] + " " + self.c_verse["verse"]
            content = VERSE_TEMPLATE % self.c_verse
            print SWISHE_TEMPLATE % {"Path-Name": CURSUS_REF % (self.c_verse["book"], self.c_verse_id),\
                                     "Content-Length": len(content)+1,\
                                     "Document": content}  # content length is +1 because print adds an extra nl

def main():
    generate_vulgate_fragments()

if __name__ == "__main__":
    main()
