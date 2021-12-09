// Main (driver) program for managing a WASH rapid assessment
// Sergiy Radyakin, The World Bank, 2021
// Email: sradyakin@@worldbank.org

// ===== STEP 0. Configuration =================================================
    clear all
    local odir `"`c(pwd)'"'
    
    local webfile    = "rapid_assessment.pdf"
    local root       = "FORM"
    local susoid     = "3c8b2134f0bf400590cdc2ca8484b8d3$1"
    local susowspace = "november"
    findfile "privatedash.do"
    do "`r(fn)'"
    
    tempfile exportname
    tempfile tmpdir
    mkdir "`tmpdir'"
    local reportname = "report.pdf"
    local reportname = subinstr("`tmpdir'/`reportname'","\","/",.)
    
// ===== STEP 1. Download the data =============================================
    .suso = .SuSo.new "$susoserver" "$susouser" "$susopass"
    .suso.workspace = "`susowspace'"
    .suso.export2, qid("`susoid'") saveto("`exportname'") replace

// ===== STEP 2. Unpack the data ===============================================
    cd `tmpdir'
    unzipfile "`exportname'", replace

// ===== STEP 3. Build the report ==============================================
    rapida, ///
      data("`tmpdir'/`root'.dta") clear ///
      report("`reportname'") replace

// ===== STEP 4. Upload the report =============================================
    upftp , filename("`reportname'") server("$ftpserver") ///
            login("$ftpuser") password("$ftppass") ///
            remote("`webfile'")
        
// ===== STEP 5. Cleanup =======================================================
    capture erase "`reportname'"
    assert ("`tmpdir'"!="")
    cd "`tmpdir'"
    !DEL *.* /Q
    cd "`odir'"
    rmdir "`tmpdir'"

    display "Done!"

// END OF FILE