all:
	odin build . -out:wav_tools_examples.exe

opti:
	odin build . -out:wav_tools_examples.exe -o:speed

clean:
	rm wav_tools_examples.exe

run:
	./wav_tools_examples.exe


