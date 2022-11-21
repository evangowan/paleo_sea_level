The reference database uses JabRef in Bibtext mode. In order to include the language 
documentation, you need to add the following to options-->Set General Fields:


document-language:language;language-author;language-title;language-journal


The bibtex style file is a modified version of the Copernicus Journals 
style file (Copernicus publishes the EGU journals). I have modified it to
include the original language titles. I have done it this way so that
the bibtex file is compatible with a regular bibtex style file, while
including the language information in my compiled reports. 
