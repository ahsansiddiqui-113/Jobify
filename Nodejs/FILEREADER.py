import os
import PyPDF2
import docx
import sys
file_path = sys.argv[1]
filename = file_path
extension = filename.split(".")[1]
# print("Extension is : ",filename.split("/")[])
# return
ahsan = ""
if extension == 'docx' or extension == 'pdf':
    if extension == 'docx':
        # Read the file as plain text
        doc = docx.Document(filename)
        lines = []
        found_string = False
        for para in doc.paragraphs:
            for line in para.text.split('\n'):
                if 'SKILLS' in line:
                    found_string = True
                if found_string and line.strip():
                    lines.append(line)
        for i, line in enumerate(lines):
            if i == 0:
                continue
            if i != len(lines) - 1:
                ahsan += line + '-'
            else:
                ahsan += line
    elif extension == 'pdf':
        # Read the file using PyPDF2
        fFileObj = filename
        pdfReader = PyPDF2.PdfReader(fFileObj)
        text = ''
        for page in pdfReader.pages:
            text += page.extract_text()
        search_string = 'SKILLS'
        last_index = text.rfind(search_string)
        last_lines = text[last_index:].splitlines()
        for i, line in enumerate(last_lines):
            line = line.strip('•. ')
            if i == 0:
                continue
            if line:
                if i != len(last_lines) - 1:
                    ahsan += line + '-'
                else:
                    ahsan += line
else:
    ahsan = "Your file type is not supported"

print(ahsan)