state("BBQ-Win64-Shipping", "18020287")
{
    byte isLoadingFlag: 0x7935E75;
}

// TODO: Add a state for the 18156695 build
// state("BBQ-Win64-Shipping", "18156695")
// {
//     byte isLoadingFlag: 0x0;
// }

state("BBQ-Win64-Shipping", "18190041")
{
    byte isLoadingFlag: 0x79892B5;
}

state("BBQ-Win64-Shipping", "18261053")
{
    byte isLoadingFlag: 0x761AE38, 0x230, 0x20, 0x250, 0x248, 0x238, 0x350, 0x180;
}

startup
{
    Func<ProcessModuleWow64Safe, byte[]> CalcModuleHash = (module) => {
        byte[] checksum = new byte[32];
        using (var hashFunc = System.Security.Cryptography.SHA256.Create())
            using (var fs = new FileStream(module.FileName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                checksum = hashFunc.ComputeHash(fs);
        return checksum;
    };
    vars.CalcModuleHash = CalcModuleHash;

    // The SHA256 hash of the game exe used to detect game version
    vars.build_18020287 = new byte[32] {0xB3, 0x94, 0x72, 0x5F, 0xB1, 0xBF, 0x3E, 0xD4, 0xE0, 0xBC, 0xBD, 0xC1, 0x67, 0xA0, 0x68, 0x8C, 0x96, 0x9C, 0x38, 0xB9, 0x8D, 0xE4, 0x06, 0x6F, 0x4B, 0x00, 0xC8, 0x67, 0x24, 0x6E, 0x97, 0x98};
    // vars.build_18156695 = new byte[32] {0x0};
    vars.build_18190041 = new byte[32] {0x93, 0xC4, 0x5A, 0x7C, 0xB1, 0xDF, 0xED, 0x43, 0x79, 0x21, 0xEC, 0xD3, 0x00, 0xD9, 0x28, 0xA1, 0x68, 0x81, 0x51, 0xCA, 0x49, 0x71, 0x5B, 0xF2, 0x49, 0xEA, 0xE4, 0x20, 0xD0, 0x20, 0x66, 0xF3};
	vars.build_18261053 = new byte[32] {0x5F, 0xD2, 0x19, 0x06, 0xE5, 0xF8, 0x4F, 0xE0, 0xCB, 0x91, 0xDF, 0xD4, 0x3F, 0xBF, 0xBF, 0xF8, 0x57, 0x04, 0xD0, 0xDA, 0xE4, 0x3F, 0x59, 0xF5, 0xA7, 0xD8, 0x77, 0x0D, 0x17, 0xEC, 0xEC, 0xA6};

}


init
{
    byte[] checksum = vars.CalcModuleHash(modules.First());
    if (Enumerable.SequenceEqual(checksum, vars.build_18020287))
        version = "18020287";
    // else if (Enumerable.SequenceEqual(checksum, vars.build_18156695))
    //     version = "18156695";
    else if (Enumerable.SequenceEqual(checksum, vars.build_18190041))
        version = "18190041";
	else if (Enumerable.SequenceEqual(checksum, vars.build_18261053))
		version = "18261053";
    else 
        version = "unknown";
}

isLoading {
    return current.isLoadingFlag == 0;
}
