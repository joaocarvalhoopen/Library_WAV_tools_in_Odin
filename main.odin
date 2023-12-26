// File        : main.odin Example of using the WAV tools library.
// Lib name    : WAV tools in Odin
// Description : A library to read and write WAV files, in Mono or Stereo,
//               in 8 bit's or 16 bit's, for any sample rate in the Odin
//               programming language.
//
//               Super simple to use.
//
//               To read the []f32 Mono buffer or Stereo buffer from the file
//                 wav_load_file( )
//                   get_buffer_d32_normalized( )
//                   print_wav_info( )
//                 wav_info_destroy( )
//
//               To write the []f32 Mono buffer or Stereo buffer to the file
//                 wav_info_create( )
//                   set_buffer_d32_normalized( )
//                   wav_write_file( )
//                   print_wav_info( )
//                 wav_info_destroy( )
//
//              See the main.odin file for several examples of using the library.
//
// License     : MIT Open Source License
// Author      : João Nuno Carvalho
// Date        : 2023.12.26
//


package main

import wt "./wav_tools"

import "core:fmt"
import "core:math"

main :: proc ( ) {
    fmt.printf( "WAV Tools begin ...\n" )

    test_1( )

    test_2( )

    test_3( )

    test_4( )

    fmt.printf( "... end WAV Tools\n" )
}

// Read from a WAV Mono 8 bit file on disk and convert to a 32 bit float buffer (buf left).
// And prints the first 10 samples of the buffer.
// If the file is mono, the buf right is nil.
// If the file is stereo, the buf right is not nil.
test_1 :: proc ( ) {
    fmt.printf( "\ntest_1 begin ...\n" )

    // Load a WAV file and returns a WavInfo struct.
    file_name := "dog_bark.wav"
    path     := "./" 
    wav_info, wav_error := wt.wav_load_file( file_name, path )
    if wav_error.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error.(wt.Error).description
        fmt.printf( "Error loading file: %s\n", error_str )
        return
    }
    // Deletes the WavInfo struct memory.
    defer wt.wav_info_destroy( & wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & wav_info )

    // Get's the buffer WAV file data.
    fmt.printf( "\n\n==>> WAV file data\n" )
    num_channels, buf_left, buf_right := wt.get_buffer_d32_normalized( & wav_info )

    // Print the first 10 sample of the WAV file data.
    for i in 0 ..< 100 {
        if num_channels == 1 {
            fmt.printf( "[%v] : left: %v\n", i, buf_left[i] )
        } else {
            fmt.printf( "[%v] : left: %v, right: %v\n", i, buf_left[i], buf_right[i] )
        }
    }

    // Deletes the WavInfo struct memory.
    // wt.wav_info_destroy( & wav_info )

    fmt.printf( "... end test_1\n\n" )
}


// Makes a copy of a WAV file Mono 8 bit by reconstructing the WAV file header and writing
// the buffer data. From the original file to the destination file. 
// Read the file from disk and convert to a 32 bit float buffer (buf left).
// And prints the first 10 samples of the buffer.
// Creates a new wav_info structure for a new file, from zero and pass to it the
// buffer data.
// Writes the new disk to file. 
test_2 :: proc ( ) {
    fmt.printf( "\ntest_2 begin ...\n" )

    // Load a WAV file and returns a WavInfo struct.
    file_name := "dog_bark.wav"
    path     := "./" 
    wav_info, wav_error := wt.wav_load_file( file_name, path )
    if wav_error.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error.(wt.Error).description
        fmt.printf( "Error loading file: %s\n", error_str )
        return
    }
    
    // Deletes the WavInfo struct memory and clears it.
    defer wt.wav_info_destroy( & wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & wav_info )

    // Get's the buffer WAV file data.
    fmt.printf( "\n\n==>> WAV file data\n" )
    res_num_channels, buf_left, buf_right := wt.get_buffer_d32_normalized( & wav_info )

    // Print the first 10 sample of the WAV file data.
    for i in 0 ..< 10 {
        if res_num_channels == 1 {
            fmt.printf( "[%v] : left: %v\n", i, buf_left[i] )
        } else {
            fmt.printf( "[%v] : left: %v, right: %v\n", i, buf_left[i], buf_right[i] )
        }
    }

    // Fill in the data.
    new_file_name       := "dog_bark_copy.wav"
    new_path            := "./"
    new_sample_rate     := wav_info.sample_rate
    new_num_channels    := wav_info.num_channels
    new_bits_per_sample := wav_info.bits_per_sample
     
    // Create a new WavInfo struct.
    new_wav_info, wav_error_2 := wt.wav_info_create( new_file_name,
                                                      new_path,
                                                      new_num_channels,
                                                      new_sample_rate,
                                                      new_bits_per_sample )

    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, new_file_name )
        return
    }

    // Deletes the FileInfo struct memory and clears it.
    defer wt.wav_info_destroy( & new_wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & new_wav_info )

    // Write the data to the buffer data inside wav_info.
    wav_error_2 = wt.set_buffer_d32_normalized( & new_wav_info,
                                                buf_left,
                                                nil)
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, new_file_name )
        return
    }
    
    // Write the new file to disk.    
    wav_error_2 = wt.wav_write_file( & new_wav_info )
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error writing file : %s, %s\n", error_str, new_file_name )
        return
    }

    // Print the WavInfo struct.
    wt.print_wav_info( & new_wav_info )


    // Deletes the WavInfo struct memory.
    // wt.wav_info_destroy( & wav_info )

    fmt.printf( "... end test_2\n\n" )
}

// Makes a copy of a WAV file Stereo 16 bit by reconstructing the WAV file header and writing
// the buffer data. From the original file to the destination file. 
// Read the file from disk and convert to two 32 bit float buffer (buf left and buf right).
// And prints the first 10 samples of the buffer.
// Creates a new wav_info structure for a new file, from zero and pass to it the
// buffer data.
// Writes the new disk to file. 
test_3 :: proc ( ) {
    fmt.printf( "\ntest_3 begin ...\n" )

    // Load a WAV file and returns a WavInfo struct.
    file_name := "hello.wav"
    path     := "./" 
    wav_info, wav_error := wt.wav_load_file( file_name, path )
    if wav_error.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error.(wt.Error).description
        fmt.printf( "Error loading file: %s\n", error_str )
        return
    }
    
    // Deletes the WavInfo struct memory and clears it.
    defer wt.wav_info_destroy( & wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & wav_info )

    // Get's the buffer WAV file data.
    fmt.printf( "\n\n==>> WAV file data\n" )
    res_num_channels, buf_left, buf_right := wt.get_buffer_d32_normalized( & wav_info )

    // Print the first 10 sample of the WAV file data.
    for i in 0 ..< 10 {
        if res_num_channels == 1 {
            fmt.printf( "[%v] : left: %v\n", i, buf_left[i] )
        } else {
            fmt.printf( "[%v] : left: %v, right: %v\n", i, buf_left[i], buf_right[i] )
        }
    }

    // Fill in the data.
    new_file_name       := "hello_copy.wav"
    new_path            := "./"
    new_sample_rate     := wav_info.sample_rate
    new_num_channels    := wav_info.num_channels
    new_bits_per_sample := wav_info.bits_per_sample
     
    // Create a new WavInfo struct.
    new_wav_info, wav_error_2 := wt.wav_info_create( new_file_name,
                                                     new_path,
                                                     new_num_channels,
                                                     new_sample_rate,
                                                     new_bits_per_sample )

    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, new_file_name )
        return
    }

    // Deletes the FileInfo struct memory and clears it.
    defer wt.wav_info_destroy( & new_wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & new_wav_info )

    // Write the data to the buffer data inside wav_info.
    wav_error_2 = wt.set_buffer_d32_normalized( & new_wav_info,
                                                buf_left,
                                                buf_right )
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, new_file_name )
        return
    }
    
    // Write the new file to disk.    
    wav_error_2 = wt.wav_write_file( & new_wav_info )
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error writing file : %s, %s\n", error_str, new_file_name )
        return
    }

    // Print the WavInfo struct.
    wt.print_wav_info( & new_wav_info )


    // Deletes the WavInfo struct memory.
    // wt.wav_info_destroy( & wav_info )

    fmt.printf( "... end test_3\n\n" )
}

// Generates two []f32 buffers for a Stereo signal 16 bit's and saves it to a WAV file.
// And prints the first 10 samples of the buffer.
// Creates a new wav_info structure for a new file, from zero and pass to it the
// buffer data.
// Writes the new disk to file. 
test_4 :: proc ( ) {
    fmt.printf( "\ntest_4 begin ...\n" )

    // Fill in the data.
    file_name       := "sine_wave.wav"
    path            := "./"
    sample_rate     := u32( 44100 )
    num_channels    := wt.NumChannels.Stereo
    bits_per_sample := wt.BitsPerSample.BPS_16_Bits
     
    // Create a new WavInfo struct.
    wav_info, wav_error_2 := wt.wav_info_create_enum( file_name,
                                                      path,
                                                      num_channels,
                                                      sample_rate,
                                                      bits_per_sample )

    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, file_name )
        return
    }

    // Deletes the FileInfo struct memory and clears it.
    defer wt.wav_info_destroy( & wav_info )

    // Print the WavInfo struct.
    wt.print_wav_info( & wav_info )


    // Synthesis a sine wave.
    num_seconds := 4
    num_samples := int( sample_rate ) * num_seconds

    // Allocate the buffers.
    buf_left  := make( []f32, num_samples )
    defer delete( buf_left )
    buf_right  := make( []f32, num_samples )
    defer delete( buf_right )


    // Fill the buffer with the sine wave with amplitude 0.2 .
    amplitude := f32( 0.2 )
    for i in 0 ..< int( num_samples ) {
        t := f32( i ) / f32( sample_rate )
        buf_left[ i ] = amplitude * math.sin_f32( 2.0 * math.PI * 440.0 * t )
        buf_right[ i ] = buf_left[ i ]
    }

    // Write the data to the buffer data inside wav_info.
    wav_error_2 = wt.set_buffer_d32_normalized( & wav_info,
                                                buf_left,
                                                buf_right )
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error creating file_info : %s, %s\n", error_str, file_name )
        return
    }
    
    // Write the new file to disk.    
    wav_error_2 = wt.wav_write_file( & wav_info )
    if wav_error_2.(wt.Error).type != wt.ErrorType.No_Error {
        error_str := wav_error_2.(wt.Error).description
        fmt.printf( "Error writing file : %s, %s\n", error_str, file_name )
        return
    }

    // Print the WavInfo struct.
    wt.print_wav_info( & wav_info )


    // Deletes the WavInfo struct memory.
    // wt.wav_info_destroy( & wav_info )

    fmt.printf( "... end test_4\n\n" )
}

