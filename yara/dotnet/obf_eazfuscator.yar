rule SUSP_OBF_NET_Eazfuscator_String_Encryption_Jan24
{
	meta:
		description = "Detects .NET images obfuscated with Eazfuscator string encryption. Eazfuscator is a widely used commercial obfuscation solution used by both legitimate software and malware."
		author = "Jonathan Peters"
		date = "2024-01-01"
		reference = "https://www.gapotchenko.com/eazfuscator.net"
		hash = "3a9ee09ed965e3aee677043ba42c7fdbece0150ef9d1382c518b4b96bbd0e442"
		score = 60
	strings:
		$sa1 = "StackFrame" ascii
		$sa2 = "StackTrace" ascii
		$sa3 = "Enter" ascii
		$sa4 = "Exit" ascii

		$op1 = { 11 ?? 18 91 11 ?? 1? 91 1F 10 62 60 11 ?? 1? 91 1E 62 60 11 ?? 17 91 1F 18 62 60 }
		$op2 = { D1 28 ?? 00 00 0A 0? 1F 10 63 D1 }
		$op3 = { 1F 10 63 D1 28 [3] 0A }
		$op4 = { 7B ?? 00 00 04 16 91 02 7B ?? 00 00 04 17 91 1E 62 60 02 7B ?? 00 00 04 18 91 1F 10 62 60 02 7B ?? 00 00 04 19 91 1F 18 62 60 } // (int)this.\u0003[0] | ((int)this.\u0003[1] << 8) | ((int)this.\u0003[2] << 0x10) | ((int)this.\u0003[3] << 0x18);
	condition:
		uint16(0) == 0x5a4d 
		and all of ($sa*) 
		and (
			2 of ($op*) 
			or
			#op1 == 2
		)
}

rule SUSP_OBF_NET_Eazfuscator_Virtualization_Jan24
{
	meta:
		description = "Detects .NET images obfuscated with Eazfuscator virtualization protection. Eazfuscator is a widely used commercial obfuscation solution used by both legitimate software and malware."
		author = "Jonathan Peters"
		date = "2024-01-02"
		reference = "https://www.gapotchenko.com/eazfuscator.net"
		hash = "53d5c2574c7f70b7aa69243916acf6e43fe4258fbd015660032784e150b3b4fa"
		score = 60
	strings:
		$sa1 = "BinaryReader" ascii
		$sa2 = "GetManifestResourceStream" ascii
		$sa3 = "get_HasElementType" ascii

		$op1 = { 28 [2] 00 06 28 [2] 00 06 72 [2] 00 70 ?? 1? 2D 0? 26 26 26 26 2B }
		$op2 = { 7E [3] 04 2D 3D D0 [3] 02 28 [3] 0A 6F [3] 0A 72 [3] 70 6F [3] 0A 20 80 00 00 00 8D ?? 00 00 01 25 D0 [3] 04 28 [3] 0A 28 [3] 06 28 [3] 06 80 [3] 04 7E [3] 04 2A } // VM Stream Init
		$op3 = { 02 20 [4] 1F 09 73 [4] 7D [3] 04 }
	condition:
		uint16(0) == 0x5a4d 
		and all of ($sa*)
		and 2 of ($op*)
}
