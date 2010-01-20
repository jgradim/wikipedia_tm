TARGET=ssim_final

all:
	latex $(TARGET).tex
	latex $(TARGET).tex
	latex $(TARGET).tex
	dvipdfm $(TARGET).dvi
clean:
	rm -f $(TARGET).pdf $(TARGET).log $(TARGET).aux $(TARGET).dvi
rebuild: clean all
