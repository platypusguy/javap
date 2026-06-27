// javap written in qlang
import cli
import fs
import io

// logging controls writing of analysis updates to stdout
const { logging = true }

main() {
	args := cli.args()

	if args.len == 0 {
		showUsage()
		return
	}

//	loop i := 0..args.len {
//		read(args[i])
//	}

	classBytes := read(args[0])
	analyze(classBytes)
}

read(path string) -> []byte {
	classbytes, err := fs.readFile(path)

	if err != 0 {
		io.write("error reading file: ")
		io.writeLine(path)
	}

//	io.writeLine(classbytes)
	return classbytes
}

showUsage() {
    io.writeLine("open-source Java class dissassembler (c) 2026 Andrew Binstock")
	io.writeLine("Usage: javap [options] filename")
	io.writeLine("       output is written to the console")
}

analyze(bytes []byte) {
	// check that the four-byte header is valid
	if bytes[0] != 0xCA || bytes[1] != 0xFE || bytes[2] != 0xBA || bytes[3] != 0xBE {
		io.writeLine("invalid Java class file")
	}

	// get the Java version
	minorVersion := getu16(bytes[4], bytes[5])
	majorVersion := getu16(bytes[6], bytes[7])
	if logging {
		versionName := ""
		switch{ 
			majorVersion <  55 {versionName = "pre-JDK 11"}
			majorVersion == 55 {versionName = "JDK 11"}
			majorVersion == 56 {versionName = "JDK 12"}
			majorVersion == 57 {versionName = "JDK 13"}
			majorVersion == 58 {versionName = "JDK 14"}
			majorVersion == 59 {versionName = "JDK 15"}
			majorVersion == 60 {versionName = "JDK 16"}
			majorVersion == 61 {versionName = "JDK 17"}
			majorVersion == 62 {versionName = "JDK 18"}
			majorVersion == 63 {versionName = "JDK 19"}
			majorVersion == 64 {versionName = "JDK 20"}
			majorVersion == 65 {versionName = "JDK 21"}
			majorVersion == 66 {versionName = "JDK 22"}
			majorVersion == 67 {versionName = "JDK 23"}
			majorVersion == 68 {versionName = "JDK 24"}
			majorVersion == 69 {versionName = "JDK 25"}
			majorVersion == 70 {versionName = "JDK 26"}
		}
		if versionName != "" {
			io.write("Java version: ")
			io.writeLine(versionName)
		}
	}
}

getu16(msb byte, lsb byte) -> int {
	return( ((msb as int) *256) + lsb )
}