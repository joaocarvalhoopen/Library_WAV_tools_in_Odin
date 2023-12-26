# Library WAV tools in Odin
A simple library to read and write WAV files for the Odin programming language.

## Description
A library to read and write WAV files, in Mono or Stereo, in 8 bit's or 16 bit's, for any sample rate in the Odin programming language.

## Super simple to use.

To read the ```[]f32``` Mono buffer or Stereo buffer from the file

``` odin
wav_load_file( )
    get_buffer_d32_normalized( )
    print_wav_info( )    <-- Optional
wav_info_destroy( )
```

To write the []f32 Mono buffer or Stereo buffer to the file

``` odin
wav_info_create( )
    set_buffer_d32_normalized( )
    wav_write_file( )
    print_wav_info( )    <-- Optional
wav_info_destroy( )
```

See the main.odin file for several examples of using the library.

## License
MIT Open Source License

## Have fun
Best regards, <br>
João Nuno Carvalho
