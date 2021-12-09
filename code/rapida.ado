// Sergiy Radyakin, The World Bank, 2021
// Email: sradyakin@@worldbank.org

program define rapida
    // Produce a rapid assessment report 
    version 16.1
    syntax , ///
      data(string)   /* Input data to load and process */ ///
      report(string) /* Report file name (will be produced) */ ///
      [clear]        /* Allows to discard unsaved data in memory. */ ///
      [replace]      /* Allows to overwrite the output file (report). */
    
    // Constants
    local bc "lime" 
    local pagew=8  // page width in inches
    local pageh=10 // page height in inches
    local c1=80
    local nLines=27
    local nCols=2
    
    use `"`data'"', `clear'
    
    #delimit ;

    putpdf begin;

    putpdf paragraph; 
    putpdf text ("WASH IN HEALTH-CARE FACILITIES"),      linebreak(1);
    putpdf text ("EMERGENCY RAPID ASSESSMENT TOOL"),     linebreak(2);
    putpdf text ("`c(current_date)' `c(current_time)'"), linebreak(2);

    putpdf table t1=(`nLines',`nCols'), width(`c1',`=100-`c1'');

    summarize waterQuantity__1, meanonly; 
    local w1=r(mean)*100;
    summarize waterQuantity__2, meanonly; 
    local w2=r(mean)*100;
    summarize waterQuantity__3, meanonly; 
    local w3=r(mean)*100;
    summarize numPeople if !missing(numPeople, numWaterPoints), meanonly; 
    local s1=r(sum);
    summarize numWaterPoints if !missing(numPeople, numWaterPoints), meanonly; 
    local s2=r(sum);
    local w4=ceil(`s1'/`s2');
    summarize waterQuality__1, meanonly; 
    local w5=r(mean)*100;
    summarize waterQuality__2, meanonly; 
    local w6=r(mean)*100;
    summarize waterQuality__3, meanonly; 
    local w7=r(mean)*100;

    putpdf table t1(1,1) = ("WATER SUPPLY");
    putpdf table t1(1,1), bgcolor(`bc');
    putpdf table t1(1,2), bgcolor(`bc');
    putpdf table t1(2,1) = ("% Health-care facilities reporting insufficient water for all daily needs");
    putpdf table t1(2,2) = ("`w1'%"), halign(center);
    putpdf table t1(3,1) = ("% Health-care facilities reporting daily interruptions in water supply");
    putpdf table t1(3,2) = ("`w2'%"), halign(center);
    putpdf table t1(4,1) = ("% Health-care facilities with insufficient water storage (less than 24 hours)");
    putpdf table t1(4,2) = ("`w3'%"), halign(center);
    putpdf table t1(5,1) = ("Average functional water point coverage (persons / functional water point)");
    putpdf table t1(5,2) = ("`w4'"), halign(center);
    putpdf table t1(6,1) = ("% Health-care facilities with source of contamination within 10m of water source");
    putpdf table t1(6,2) = ("`w5'%"), halign(center);
    putpdf table t1(7,1) = ("% Health-care facilities with unchlorinated or insufficiently chlorinated water");
    putpdf table t1(7,2) = ("`w6'%"), halign(center);
    putpdf table t1(8,1) = ("% Health-care facilities with broken pipes or unsanitary reservoirs");
    putpdf table t1(8,2) = ("`w7'%"), halign(center);

    // todo: this must be total persons over total toilets
    summarize numPeople5 if !missing(numPeople5, numToilets), meanonly; 
    local s1=r(sum);
    summarize numToilets if !missing(numPeople5, numToilets), meanonly; 
    local s2=r(sum);
    local e1=ceil(`s1'/`s2');

    summarize drainage__1, meanonly; 
    local e2=r(mean)*100;
    summarize drainage__2, meanonly; 
    local e3=r(mean)*100;
    summarize drainage__3, meanonly; 
    local e4=r(mean)*100;
    
    putpdf table t1(9,1) = ("EXCRETA DISPOSAL AND DRAINAGE");
    putpdf table t1(9,1), bgcolor(`bc');
    putpdf table t1(9,2), bgcolor(`bc');
    putpdf table t1(10,1) = ("Average functional and clean toilet coverage (persons / functional toilet)");
    putpdf table t1(10,2) = ("`e1'"), halign(center);
    putpdf table t1(11,1) = ("% Health-care facilities with standing water at water points");
    putpdf table t1(11,2) = ("`e2'%"), halign(center);
    putpdf table t1(12,1) = ("% Health-care facilities with grey water visible in environment");
    putpdf table t1(12,2) = ("`e3'%"), halign(center);
    putpdf table t1(13,1) = ("% Facilities with stormwater drains / ditches blocked or non-functional");
    putpdf table t1(13,2) = ("`e4'%"), halign(center);

    summarize wasteManagement__1, meanonly; 
    local m1=r(mean)*100;
    summarize wasteManagement__2, meanonly; 
    local m2=r(mean)*100;
    summarize wasteManagement__3, meanonly; 
    local m3=r(mean)*100;
    
    putpdf table t1(14,1) = ("WASTE MANAGEMENT");
    putpdf table t1(14,1), bgcolor(`bc');
    putpdf table t1(14,2), bgcolor(`bc');
    putpdf table t1(15,1) = ("% Health facilities with insufficient, inadequate, or overflowing waste containers");
    putpdf table t1(15,2) = ("`m1'%"), halign(center);
    putpdf table t1(16,1) = ("% Facilities with no separation of wastes (e.g. infectious, non-infectious, sharps)");
    putpdf table t1(16,2) = ("`m2'%"), halign(center);
    putpdf table t1(17,1) = ("% Facilities lacking fenced disposal area or health-care waste in environment");
    putpdf table t1(17,2) = ("`m3'%"), halign(center);

    summarize diseaseControl__1, meanonly; 
    local d1=r(mean)*100;
    summarize diseaseControl__2, meanonly; 
    local d2=r(mean)*100;
    summarize diseaseControl__3, meanonly; 
    local d3=r(mean)*100;
    
    putpdf table t1(18,1) = ("DISEASE VECTOR CONTROL");
    putpdf table t1(18,1), bgcolor(`bc');
    putpdf table t1(18,2), bgcolor(`bc');
    putpdf table t1(19,1) = ("% Health-care facilities with beds that are missing impregnated mosquito nets");
    putpdf table t1(19,2) = ("`d1'%"), halign(center);
    putpdf table t1(20,1) = ("% Health-care facilities with food stuffs unprotected from flies, insects, rats");
    putpdf table t1(20,2) = ("`d2'%"), halign(center);
    putpdf table t1(21,1) = ("% Health-care facilities with vector breeding sites identified in / around facility");
    putpdf table t1(21,2) = ("`d3'%"), halign(center);

    summarize infectionControl__1, meanonly; 
    local h1=r(mean)*100;
    summarize infectionControl__2, meanonly; 
    local h2=r(mean)*100;
    summarize handwashing__1, meanonly; 
    local h3=r(mean)*100;
    summarize infectionControl__4, meanonly; 
    local h4=r(mean)*100;
    summarize handwashing__3, meanonly; 
    local h5=r(mean)*100;

    putpdf table t1(22,1) = ("INFECTION CONTROL AND HANDWASHING");
    putpdf table t1(22,1), bgcolor(`bc');
    putpdf table t1(22,2), bgcolor(`bc');
    putpdf table t1(23,1) = ("% Facilities lacking one month supply of chlorine or cleaning equipment");
    putpdf table t1(23,2) = ("`h1'%"), halign(center);
    putpdf table t1(24,1) = ("% Health-care facilities with floors, walls, equipment, bedding visibly insanitary");
    putpdf table t1(24,2) = ("`h2'%"), halign(center);
    putpdf table t1(25,1) = ("% Facilities lacking functional handwashing points where health-care delivered");
    putpdf table t1(25,2) = ("`h3'%"), halign(center);
    putpdf table t1(26,1) = ("% Facilities lacking sufficient quantities of personal protective equipment");
    putpdf table t1(26,2) = ("`h4'%"), halign(center);
    putpdf table t1(27,1) = ("% Health facilities lacking soap and handwashing reminders");
    putpdf table t1(27,2) = ("`h5'%"), halign(center);

    # delimit cr
    
    // Chart 1
    graph hbar totalScore, ///
       over(nameLocation, sort(totalScore) descending ) ///
       ytitle("Score Out of 30") ///
       title("Health Facility Sanitary Risk Score") ///
       name(chart1) blabel(bar) plotregion(color(white)) ///
       graphregion(color(white)) bar(1, color(green))
       
    // Chart 2
    graph hbar personsPerToi~t, ///
       over(nameLocation, sort(personsPerToi~t) descending ) ///
       ytitle("People per Functional Toilet") ///
       title("Functional Water Point Coverage") ///
       name(chart2) blabel(bar) plotregion(color(white)) ///
       graphregion(color(white)) bar(1, color(brown))
       
    // Chart 3
    graph hbar personsPerPoint , ///
       over(nameLocation, sort(personsPerPoint) descending ) ///
       ytitle("People per Functional Water Point") ///
       title("Functional Water Point Coverage") ///
       name(chart3) blabel(bar) plotregion(color(white)) ///
       graphregion(color(white)) bar(1, color(ltblue))

    graph combine chart1 chart2 chart3, scale(0.66) ///
       cols(1) xsize(`pagew') ysize(`pageh') ///
       graphregion(color(white))

    tempfile itmp
    quietly graph export `"`itmp'"', replace as(png) width(1600)
    
    putpdf paragraph
    putpdf image `"`itmp'"'

    putpdf save `"`report'"', `replace'

end
  
// END OF FILE