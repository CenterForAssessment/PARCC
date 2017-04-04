---
title: "The PARCC Consortium Student Growth Model"
subtitle: "A Technical Overview of the Spring 2016 Student Growth Percentile Calculations"
author:
  - name: Damian W. Betebenner
  - name: Adam R. VanIwaarden
  - name: <em>National Center for the Improvement<br></br> of Educational Assessment (NCIEA)</em>
date: January 2017
abstract: "DRAFT REPORT - DO NOT CITE! <br></br> This report provides details about the PARCC consortium Student Growth Model methodology and presents a descriptive analysis of the 2016 SGP calculation process and results."
---






# Introduction

This report contains details on the Spring 2016 implementation of the student growth percentiles (SGP) model for the [Partnership for Assessment of Readiness for College and Careers (PARCC) consortium](http://www.parcconline.org/) and Pearson Education ([Pearson](http://www.pearsoned.com/)).  The National Center for the Improvement of Educational Assessment ([NCIEA](http://www.nciea.org)) contracted with Pearson to implement the SGP methodology using data derived from the PARCC assessments to create the PARCC Student Growth Model.  The goal of the engagement with Pearson is to create a set of open source analytic techniques and conduct the first year of growth analyses.  These analyses will be conducted exclusively by Pearson in following years.

The SGP methodology is an open source norm- and criterion-referenced student growth analysis that produces student growth percentiles and student growth projections/targets for each student in the PARCC consortium with adequate longitudinal data.  This methodology is currently used for many purposes, including parent/student diagnostic reporting, institutional improvement, and school and educator accountability.  Specifics about the manner in which growth is included in each PARCC member states' accountability systems can be provided by their respective state education agencies.   

This report includes four sections:

- ***Data - *** includes details on the decision rules used in the raw data preparation and student record validation.
- ***Analytics - *** introduces some of the basic statistical methods and the computational process implemented in the 2016 analyses.^[More in-depth treatment of the SGP Methodology can be found [here](https://github.com/CenterForAssessment/SGP_Resources/tree/master/articles) and in Appendix B of this report.]
- ***Goodness of Fit - *** investigates how well the statistical models used to produce SGPs fit PARCC consortium students' data.  This includes discussion of goodness of fit plots and the student-level correlations between SGPs and prior achievement.
- ***SGP Results - *** provides basic descriptive statistics from the 2016 analyses at both the state and school levels.

This report also includes multiple appendices.  Appendix A displays Goodness of Fit plots for each analysis conducted in 2016.  Appendix B provides a more comprehensive discussion of the SGP methodology.  Appendix C is an investigation of potential ceiling and/or floor effects present in the PARCC consortium assessment data and growth analyses.



# Data

Data for the PARCC grade level and end-of-course tests (EOCT) used in the SGP analyses were supplied by Pearson to the NCIEA for analysis in the summer of 2016.  These PARCC test records were added to PARCC assessment program data from the spring 2015 and fall 2015 test administrations to create the longitudinal data set from which the spring 2016 SGPs were calculated.  Subsequent years' analyses will augment this multi-year data set allowing Pearson to maintain a comprehensive longitudinal data set for all students taking the PARCC assessments.

Student Growth Percentiles have been produced for students that have a current score and at least one prior score in either the same subject or a related content area.  For the 2016 academic year SGPs were produced for grade-level English Language Arts (ELA) and Mathematics, as well as for EOCT subjects including Algebra I, Algebra II, Geometry, and Integrated Mathematics 1 through 3.

## Longitudinal Data
Growth analyses of assessment data require test scores that are linked to individual students over time.  Student growth percentile analyses require, at a minimum two (and preferably more) years of assessment data for analysis of student progress.  To this end it is necessary that a unique student identifier be available so that student data records across years can be merged with one another and subsequently examined.  Because some records in the assessment data set contain students with more than one test score in a content area in a given year, a process to create unique student records in each content area by year combination was required.  

Table 1 shows the number of valid grade level student records available for analysis after applying a set of general business rules.  The final raw data submissions provided by Pearson contained no duplicate records or other problematic cases, and therefore these records are all considered valid for use in the SGP models.^[This number does not represent the number of SGPs produced, however, because students are required to have at least one prior score available as well.]




<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='11' style='text-align: left;'>
**Table 1:** Number of Valid Grade Level Student Records by Grade and Subject for 2016</td></tr>
<tr>
<th colspan='1' style='font-weight: 900; border-top: 2px solid grey; text-align: center;'></th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='9' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grades</th>
</tr>
<tr>
<th style='border-bottom: 1px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>3</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>4</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>5</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>6</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>7</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>8</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>9</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>10</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>11</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>ELA</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='text-align: right;'>472,408</td>
<td style='text-align: right;'>461,686</td>
<td style='text-align: right;'>456,671</td>
<td style='text-align: right;'>456,997</td>
<td style='text-align: right;'>450,997</td>
<td style='text-align: right;'>441,617</td>
<td style='text-align: right;'>278,231</td>
<td style='text-align: right;'>195,612</td>
<td style='text-align: right;'>139,109</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Mathematics</td>
<td style='border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>477,296</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>465,122</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>458,941</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>459,031</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>436,963</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>360,753</td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
</tr>
</tbody>
</table>




Table 2 shows the total number of valid EOCT student records from spring 2016 available for analysis.



<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='2' style='text-align: left;'>
**Table 2:** Total Number of Valid EOCT Student Records by Subject for 2016</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Valid Records</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>Algebra I</td>
<td style='text-align: right;'>327,946</td>
</tr>
<tr>
<td style='text-align: right;'>Algebra II</td>
<td style='text-align: right;'>141,946</td>
</tr>
<tr>
<td style='text-align: right;'>Geometry</td>
<td style='text-align: right;'>147,094</td>
</tr>
<tr>
<td style='text-align: right;'>Integrated Math 1</td>
<td style='text-align: right;'>16,761</td>
</tr>
<tr>
<td style='text-align: right;'>Integrated Math 2</td>
<td style='text-align: right;'>4,780</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Integrated Math 3</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>2,380</td>
</tr>
</tbody>
</table>



# Analytics

This section provides basic details about the calculation of student growth percentiles from PARCC consortium assessment data using the [`R` Software Environment](http://www.r-project.org/) [@Rsoftware] in conjunction with the [`SGP` package](https://github.com/CenterForAssessment/SGP) [@sgp2016].  More in depth treatment of the data analysis process with code examples has been provided to Pearson staff directly.

Broadly, the SGP analysis of the PARCC consortium longitudinal student assessment data takes place in two steps:

1. Data Preparation
2. Data Analysis

Those familiar with data analysis know that the bulk of the effort in the above two step process lies with Step 1: Data Preparation.  Following thorough data cleaning and preparation, data analysis using the `SGP` package takes clean data and makes it as easy as possible to calculate, output and visualize the results from SGP analyses.


## Data Preparation

The data preparation step involves taking PARCC consortium assessment data provided by the Pearson Education Corporation and producing a single file that will be subsequently analyzed in Step 2. This process is carried out annually as new data becomes available from the state assessment program.

The data required for the Spring 2016 SGP Analyses were provided at two separate time points, and therefore the data preparation and cleaning was performed in two steps.  Data from three previous testing periods were provided to the Center for Assessment in early June 2016, which were used as the prior test scores (i.e. independent variables) in the Spring 2016 Analyses.  Data from the spring 2016 testing period (the dependent variable) was provided to the Center for Assessment in July 2016.  In both deliveries the data were provided as individual comma separated values (.csv) files for each state in the PARCC consortium. 

A custom function was used to read each state specific file into `R` and simultaneously combine them into a single data table.  The data was then cleaned up variable by variable to ensure that it conforms to data naming and variable format conventions used in the `SGP` software package.  The result is a `.Rdata` file containing data in the format suitable for analysis with the `SGP` package.  With an appropriate longitudinal data set prepared, we continued on with the calculation of student-level SGPs.

## Data Analysis

The objective of the student growth percentile (SGP) analysis is to describe how (a)typical a student's growth is by examining his/her current achievement relative to students with a similar achievement history; i.e his/her *academic peers* (see [this presentation](https://github.com/CenterForAssessment/SGP_Resources/blob/master/presentations/Academic_Peer_Slides.pdf) for a detailed description of this concept). This norm-referenced growth quantity is estimated using quantile regression [@Koenker:2005] to model curvilinear functional relationships between student's prior and current scores.  One hundred such regression models are calculated for each separate analysis (defined as a unique ***year** by **content area** by **grade** by **prior order*** combination).  The end product of these 100 separate regression models is a single coefficient matrix, which serves as a look-up table to relate prior student achievement to current achievement for each percentile. This process ultimately leads to tens of thousands of model calculations during each of the PARCC consortium's seasonal batch of analyses (and many more when simulation-extrapolation, or SIMEX, methods of measurement error corrections are performed).  For a more in-depth discussion of SGP calculation, see Betebenner [-@Betebenner:2009] and Appendix B of this report, and see Shang, VanIwaarden and Betebenner [-@ShangVanIBet:2015] for further information on the SIMEX measurement error correction methodology.

The Spring 2016 PARCC SGP analyses follow a work flow that includes the following four steps:

1. Update the PARCC assessment meta-data required for SGP calculations using the `SGP` package.
2. Create SGP configurations for analyses.
3. Conduct all grade level and EOCT SGP analyses.
4. Combine results into the master longitudinal data set and output data in the format requested by Pearson.

### Update PARCC meta-data

The use of higher-level functions included in the `SGP` package (e.g. `analyzeSGP`) requires the availability of state specific assessment information.  The meta-data for all States and other education agencies is compiled in a `R` data file named `SGPstateData` that is housed in the package.  The initial PARCC meta-data entry included *a)* the knots and boundary values for each assessment score distribution, *b)* the proficiency level cutscores designated by Pearson and the PARCC consortium members, and *c)* a table that identifies an ordered preference for norm groups from which SGPs might be produced.  Other SGP configuration metadata was ultimately included in the PARCC `SGPstateData` entry, which can be viewed [here on Github](https://github.com/CenterForAssessment/SGPstateData/blob/052fc248ffa7fbe196cb75a58efdfac3cfae3c1d/SGPstateData.R#L19).

<div class='caption'>**Knots and boundaries**</div>
Cubic B-spline basis functions are used in the calculation of SGPs to more adequately model the heteroscedasticity and non-linearity found in assessment data.  These functions require the selection of boundary and interior knots.  Boundary knots (i.e. "boundaries") are end-points outside of the test score distribution that anchor the B-spline basis.  These are typically selected by extending the entire range of test scores by 10%.  That is, they are defined as lying 10% below the lowest obtainable/observed scale score (LOSS) and 10% above the highest obtainable/observed scale score (HOSS).  The interior knots (i.e. "knots") are the *internal* breakpoints that define the spline.  The default choice in the `SGP` package is to select the 20<sup>th</sup>, 40<sup>th</sup>, 60<sup>th</sup> and 80<sup>th</sup> quantiles of the observed scale score distribution.

In general the knots and boundaries are computed from a distribution comprised of several years of test data (i.e. multiple cohorts combined into a single distribution) so that any irregularities in a single year are smoothed out.  This is important because subsequent annual analyses use these same knots and boundaries as well.  All defaults were used to compile the knots and boundaries for PARCC using the two available years of test data.

<div class='caption'>**Proficiency level cutscores**</div>
Cutscores, which are set externally by the PARCC consortium through standard-setting processes, are mainly required for student growth projections.  Cutscores for all content areas and grade levels were added.  Additionally, cutscores corresponding to both the scaled scores and the base scores (Item Response Theory "theta" values) are included in the PARCC meta-data entry. 

<div class='caption'>**Norm group preferences**</div>
The process through which some SGP analyses are run can produce multiple SGPs for some students (particularly in EOCT math where students may have multiple prior math test scores).  In order to identify which quantity will be used as the students' "official" SGP and subsequently merged into the master longitudinal data set, a system of norm group preferencing is established and is encoded into a lookup table included in the `SGPstateData`.  In general, preference is given to:

- Progressions with the most recent prior scale score.
- Progressions with the most common course progression, which is generally also used in student growth projections (in order to ensure correspondence between their reported growth percentile and projection).
- Progressions with the greatest number of prior scale scores.

The next section describes the process by which individual course progressions are established with analyses configuration code, which incorporates the preferencing system within it.


### Specify SGP configurations

Many SGP analyses are specialized enough that it is necessary to specify each analyses to be performed via explicit configuration code.  Such configurations were required to conduct the EOCT mathematics SGP analyses for the PARCC consortium.  Although not necessary for the grade level content areas, explicit configuration code were also used for these analyses to provide greater coding consistency and allow for all analyses to be run concurrently.

Configurations are `R` code scripts that are used primarily in the SGP analysis to be discussed later, but are also used initially to construct the norm group preference object prior to analysis.  They are broken up into four separate R scripts based on content domain (ELA and mathematics) and test score metric (IRT theta and scaled scores).  Each configuration code chunk specifies a set of parameters that defines the norm group of students to be examined.  Every potential norm group is defined by, at a minimum, the progressions of content area, academic year and grade-level.  Therefore, every configuration used contains the first three elements and some analyses also contain the fourth and/or fifth elements:

- **`sgp.content.areas`:** The ordered progression of content areas to be looked at.
- **`sgp.panel.years`:** The progression of the years associated with the content area progression (`sgp.content.areas`), potentially allowing for skipped or repeated years, fall to spring within year analyses, etc.  Because some PARCC states administer tests in both Fall and Spring, a season or period indicator is required as well.  This is encoded here as either a ".1" or ".2" suffix to the academic year ("2015_2016.1" for Fall 2015 and "2015_2016.2" for Spring 2016). 
- **`sgp.grade.sequences`:** The grade progression associated with the configuration content areas and years. The value **'EOCT'** stands for 'End Of Course Test'.  The use of the generic 'EOCT' allows for secondary students to be compared based on the pattern of course taking rather than being dependent upon grade-level designation.
- **`sgp.projection.grade.sequences`:** This element is used to identify the grade sequence that will be used to produce student growth projections.  It can either be left out or set explicitly to `NULL` to produce projections based on the values provided in the `sgp.content.areas` and `sgp.grade.sequences` elements.  Alternatively, when set to "`NO_PROJECTIONS`", no projections will be produced.  For EOCT analyses, only configurations that correspond to the canonical course progressions can produce student growth projections.  The canonical progressions are codified in the `SGP` package here: [`SGPstateData[["PARCC"]][["SGP_Configuration"]][["content_area.projection.sequence"]]`](https://github.com/CenterForAssessment/SGPstateData/blob/052fc248ffa7fbe196cb75a58efdfac3cfae3c1d/SGPstateData.R#L115).  Note also that grade level Mathematics can have two different EOCT trajectories - one that follows the Integrated Math courses and another that goes from Algebra I to Geometry to Algebra II.   
- **`sgp.norm.group.preference`:** Because a student can potentially be included in more than one analysis/configuration, multiple SGPs will be produced for some students and a system is required to identify the preferred SGP that will be matched with the student in the `combineSGP` step.  This argument provides a numeric ranking that specifies how preferable SGPs produced from the analysis in question is relative to other possible analyses.  ***Lower numbers correspond with higher preference.***


As an example, here is the Algebra I configuration used to define the 2016 SGP analysis with the highest preference:

```R
...

	ALGEBRA_I.2015_2016 = list(
		sgp.content.areas=c("MATHEMATICS", "ALGEBRA_I"),
		sgp.panel.years=c("2014_2015.2", "2015_2016.2"),
		sgp.grade.sequences=list(c("8", "EOCT")),
		sgp.norm.group.preference=0),

...

```


### Conduct SGP analyses

All cohort-referenced (unadjusted) and SIMEX corrected grade level and EOCT SGPs were calculated concurrently.  Data analysis is conducted using the [`R` Software Environment](http://www.r-project.org/) in conjunction with the [`SGP` package](https://github.com/CenterForAssessment/SGP). Broadly, the analysis takes place in 6 steps.

1. `prepareSGP`
2. `analyzeSGP`
3. `combineSGP`
4. `summarizeSGP`
5. `visualizeSGP`
6. `outputSGP`

Because these steps are almost always conducted simultaneously, the `SGP` package has wrapper functions `abcSGP` and `updateSGP` that "wrap" the above 6 steps into a single function call and simplify the source code associated with the analysis.  Documentation for all SGP functions can be found [at this online link.](https://cran.r-project.org/web/packages/SGP/SGP.pdf)

SGP analyses were conducted at both the consortium and state level.  In the consortium analyses we use the `updateSGP` function to ***a)*** do the final preparation and addition of the cleaned and formatted Spring 2016 data to an `SGP` class object created for the Fall 2015 analyses (`prepareSGP` step) and ***b)*** calculate SGP estimates (`analyzeSGP` step).  In the individual state analyses, these two steps were performed using the individual functions separately in order to establish the states' `SGP` class objects (i.e. Fall state-level analyses were not feasible due to small cohort sizes).

### Merge, output, summarize and visualize results

Once all analyses were completed the results were merged into the master longitudinal data set (`combineSGP` step).  A pipe delimited version of the complete long data is output (`outputSGP` step) and submitted to Pearson after some additional formatting to add requested information.  Finally, visualizations (such as growth achievement charts) are produced from the results data using the `visualizeSGP` function.



# Goodness of Fit

Despite the use of B-splines to accommodate heteroscedasticity and skewness of the test score distributions, assumptions that are made in the statistical modeling process can impact how well the percentile curves fit the data.  Examination of goodness-of-fit was conducted by first inspecting model fit plots the `SGP` software package produces for each analysis, and subsequently inspecting student level correlations between growth and achievement.  Discussion of the model fit plots in general and examples of them are provided below, as are tables of the correlation results.  The complete portfolio of model fit plots is provided in Appendix A of this report.

## Model Fit Plots

Using all available grade level and EOCT scores as the variables, estimation of student growth percentiles was conducted for each possible student (those with a current score and at least one prior score).  Each analysis is defined by the grade and content area for the grade-level analyses and exact content area (and grade when relevant) sequences for the EOCT subjects.  A goodness of fit plot is produced for each unique analysis run in 2016 and are all provided in Appendix A to this report.

As an example, Figure 1 shows the results for 8<sup>th</sup> grade ELA as an example of good model fit.  Figure 2 demonstrates minor model misfit in the Integrated Mathematics 1 analyses that uses 2015 Grade 7 Mathematics for its prior scores.

The "Ceiling/Floor Effects Test" panel is intended to help identify potential problems in SGP estimation at the Highest and Lowest Obtainable (or Observed) Scale Scores (HOSS and LOSS).  Most often these effects are caused when it is relatively typical for extremely high (low) achieving students to consistently score at or near the HOSS (LOSS) each year leading to the SGPs for these students to be unexpectedly low (high).  That is, for example, if a sufficient number of students maintain performance at the HOSS over time, this performance will be estimated as typical, and therefore SGP estimates will reflect typical growth (e.g. 50th percentile).  In some cases small deviations from these extreme score values might even yield low growth estimates.  Although these score patterns can legitimately be estimated as typical or low growth percentile, it is potentially an unfair description of student growth (and by proxy teacher or school, etc. performance metrics that use them).  Ultimately this is an artifact of the assessments' inability to adequately measure student performance at extreme ability levels.  

The table of values here shows whether the current year scores at both extremes yield the expected SGPs^[Note that the prior year scores are not represented here, but are also a critical factor in ceiling effects.].  The expectation is that the majority of SGPs for students scoring at or near the LOSS will be low (preferably less than 5 and not higher than 10), and that SGPs for students scoring at or near the HOSS will be high (preferably higher than 95 and not less than 90).  Because few students may score *exactly* at the HOSS/LOSS, the top/bottom 50 students are selected and any student scoring within their range of scores are selected for inclusion in these tables.  Consequently, there may be a range of scores at the HOSS/LOSS rather than a single score, and there may be more than 50 students included in the HOSS/LOSS row if the 50 students at the extremes only contain the single HOSS/LOSS score.

This table is meant to serve more as a "canary in the coal mine" than as a detailed, conclusive indicator of ceiling or floor effects, and a more fine grained analysis that considers the relationship between score histories and SGPs may be necessary.  Appendix C of this report provides a more in depth investigation of potential ceiling effects.

The two bottom panels compare the observed conditional density of the SGP estimates with the theoretical (uniform) density.  The bottom left panel shows the empirical distribution of SGPs given prior scale score deciles in the form of a 10 by 10 cell grid.  Percentages of student growth percentiles between the 10<sup>th</sup>, 20<sup>th</sup>, 30<sup>th</sup>, 40<sup>th</sup>, 50<sup>th</sup>, 60<sup>th</sup>, 70<sup>th</sup>, 80<sup>th</sup>, and 90<sup>th</sup> percentiles were calculated based upon the empirical decile of the cohort's prior year scaled score distribution^[The total students in each analysis varies depending on grade and subject, and prior score deciles are based only on scores for students used in the SGP calculations.].  With an infinite population of test takers, at each prior scaled score, with perfect model fit, the expectation is to have 10 percent of the estimated growth percentiles between 1 and 9, 10 and 19, 20 and 29, ..., and 90 and 99.  Deviations from 10 percent, indicated by red and blue shading, suggests lack of model fit.  The further *above* 10 the darker the red, and the further *below* 10 the darker the blue.  

When large deviations occur, one likely cause is a clustering of scale scores that makes it impossible to "split" the score at a dividing point forcing a majority of the scores into an adjacent cell.  This occurs more often in lowest grade levels where fewer prior scores are available (particularly in the lowest grade when only a single prior is available).  Another common cause of this is small cohort size (e.g. fewer than 5,000 students).

The bottom right panel of each plot is a Q-Q plot which compares the observed distribution of SGPs with the theoretical (uniform) distribution.  An ideal plot here will show black step function lines that do not deviate greatly from the ideal, red line which traces the 45 degree angle of perfect fit.




###  Unadjusted model fit

The model fit plots for the unadjusted, cohort-referenced model results in all subjects are excellent with few exceptions (see Appendix A for all model fit plots).  Figure 1 displays the 8<sup>th</sup> grade ELA model as an exemplar of model fit, and Figure 2 is an Integrated Mathematics 1 progression which exemplifies the extent to which model misfit is present in the PARCC SGP analyses.

##### **Figure 1:**   Goodness of Fit Plot for 2016 ***Unadjusted*** 8<sup>th</sup> Grade ELA:  Example of good model fit.
![](../img/Goodness_of_Fit/ELA.2015_2016.2/gofSGP_Grade_8.png)



Minor misfit in the Integrated Mathematics 1 model is likely due to the relatively small cohort size (1,261 students), which consists of a relatively homogenous group of high achieving students who skipped 8<sup>th</sup> grade mathematics to take a high school level mathematics course.  Both of these cohort restrictions can lead to modeling problems, but we still note a relatively good distribution of SGP values across the entire spectrum of prior test score achievement.  The indication of a potential ceiling effect is not surprising given the prior achievement homogeneity of the cohort, but may be overstated given the range of scores included in the HOSS and students scoring just below the HOSS with low SGP are less concerning.  This situation is investigated in detail in Appendix C.

##### **Figure 2:**   Goodness of Fit Plot for a 2016 ***Unadjusted*** Integrated Mathematics 1 Progression: Example of slight model mis-fit.
![](../img/Goodness_of_Fit/INTEGRATED_MATH_1.2015_2016.2/2015_2016_2_INTEGRATED_MATH_1_EOCT;2014_2015_2_MATH_7.png)


###  SIMEX model fit

Although the *official* PARCC SGPs do not incorporate SIMEX measurement error correction, we provide the adjusted model fit plots here to compare with unadjusted models.  Note that both models presented here use the same student data as those in the section above.  

SIMEX model fit is not expected to be perfect.  In these models we ***expect misfit*** in the form of increased high SGPs for students with lower prior performance (and a complementary decrease in low SGPs for those students), and the reverse expectation for high achieving students.  This is visible in the goodness of fit plots in Figure 3 where the SIMEX correction method has been applied to the 8<sup>th</sup> grade ELA model, and Figure 4 for the same Integrated Mathematics 1 progression as presented above.  Most notable is the shift from blue to red in the top half (and corresponding red to blue shift in the bottom half) of the "Student Growth Percentile Range" panel.

The patterns observed in these two charts suggest that the SIMEX model adjustments are behaving as expected.

<p></p>

##### **Figure 3:**   Goodness of Fit Plot for 2016 ***SIMEX Corrected,*** 8<sup>th</sup> Grade ELA.
![](../img/Goodness_of_Fit/ELA.2015_2016.2.SIMEX/gofSGP_Grade_8.png)


##### **Figure 4:**   Goodness of Fit Plot for a 2016 ***SIMEX Corrected,*** Integrated Mathematics 1 Progression.
![](../img/Goodness_of_Fit/INTEGRATED_MATH_1.2015_2016.2.SIMEX/2015_2016_2_INTEGRATED_MATH_1_EOCT;2014_2015_2_MATH_7.png)



## Growth and Prior Achievement at the Student Level

To investigate the possibility that individual level misfit might impact summary level results, student level SGP results were examined relative to prior achievement.  With perfect fit to data, the correlation between students' most recent prior achievement scores and their student growth percentiles is zero (i.e., the goodness of fit tables would have a uniform distribution of percentiles across all previous scale score levels).  To investigate in another way, correlations between **a)** prior and current scale scores (achievement) and **b)** prior score and student growth percentiles were calculated.  Evidence of good model fit begins with a strong positive relationship between prior and current achievement, which suggests that growth is detectable and modeling it is reasonable.  A lack of relationship (zero correlation) between prior achievement and growth confirms that the model has fit the data well and produced a uniform distribution of percentiles across all previous scale score levels.

Student-level correlation coefficients ($r$) for grade level subjects are presented in Table 3, and the results are generally as expected.  Strong relationships exist between prior and current scale scores for the grade level analyses (column 3).  With cohort-referenced (unadjusted) percentiles, the correlation between students' most recent prior achievement scores and their student growth percentiles is zero when the model is perfectly fit to the data.  This also indicates that students can demonstrate high (or low) growth regardless of prior achievement.  Correlations for the PARCC consortium's unadjusted SGPs are all essentially zero (column 4).

SIMEX corrected SGPs induce a negative correlation between growth and prior achievement.  Rather than a uniform distribution, SIMEX produces a distribution in which growth for lower prior achieving students' is weighted upward and higher achieving students' growth is weighted down.  In theory, this bias in student-level SGPs may decrease the bias in aggregate growth measures [@ShangVanIBet:2015].  Subsequently, the correlations between both student- and aggregate-level "unadjusted" SGPs and prior achievement are typically higher than those with SIMEX corrected SGPs.^[Note that correlations that are initially negative will become increasingly negative rather than return to zero.]


### Grade level subjects


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='6' style='text-align: left;'>
**Table 3:** Student Level Correlations between Prior Standardized Scale Score and 1) Current Scale Score, 2) SGP and 3) SIMEX SGP.</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grade</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  Test Scores}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  SGP}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  SIMEX SGP}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>N Size</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>ELA</td>
<td style='text-align: right;'> 4</td>
<td style='text-align: right;'>0.81</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>418,864</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 5</td>
<td style='text-align: right;'>0.83</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>415,473</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 6</td>
<td style='text-align: right;'>0.82</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>413,032</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 7</td>
<td style='text-align: right;'>0.84</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>406,161</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 8</td>
<td style='text-align: right;'>0.84</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>395,857</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 9</td>
<td style='text-align: right;'>0.80</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>232,915</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>10</td>
<td style='text-align: right;'>0.78</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.06</td>
<td style='text-align: right;'>104,692</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>11</td>
<td style='text-align: right;'>0.72</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.05</td>
<td style='text-align: right;'>86,252</td>
</tr>
<tr>
<td style='text-align: right;'>Mathematics</td>
<td style='text-align: right;'> 4</td>
<td style='text-align: right;'>0.84</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>422,426</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 5</td>
<td style='text-align: right;'>0.85</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>417,351</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 6</td>
<td style='text-align: right;'>0.82</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>414,501</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> 7</td>
<td style='text-align: right;'>0.83</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>391,096</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'> 8</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>0.79</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>0.00</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>-0.09</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>312,787</td>
</tr>
</tbody>
</table>

### EOCT Subjects

Each EOCT subject is analyzed using more than one sequence of prior subjects, grades and years, and these unique progressions are disaggregated in Table 4 using the most recent prior available for each norm group (although more prior years' scores can be used in SGP calculations when available).  Unless otherwise noted, all priors are from the Spring of 2015.  The correlations between current EOCT and prior test score are generally lower than in the grade level norm groups, and overall lower correlations may be expected in EOCT subjects due to the change in specific subject from one course to the next.  

The relationships between growth and prior achievement reported in Table 4 are still non-existent for cohort referenced SGPs and slightly negative after SIMEX correction.  These results are as expected for appropriate fit to the respective models as discussed in the grade level section above.



<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='6' style='text-align: left;'>
**Table 4:** EOCT Student Level Correlations between Prior Standardized Scale Score and 1) Current Scale Score, 2) SGP and 3) SIMEX SGP - Disaggregated by Norm Group.</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Most Recent Prior</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  Test Scores}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  SGP}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>$\
r_ {  SIMEX}$</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>N Size</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>Algebra I</td>
<td style='text-align: right;'> Geometry</td>
<td style='text-align: right;'>0.67</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.11</td>
<td style='text-align: right;'>1,193</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 6</td>
<td style='text-align: right;'>0.77</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>12,884</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 7</td>
<td style='text-align: right;'>0.81</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>69,317</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 8</td>
<td style='text-align: right;'>0.67</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.10</td>
<td style='text-align: right;'>172,218</td>
</tr>
<tr>
<td style='text-align: right;'>Algebra II</td>
<td style='text-align: right;'> Algebra I</td>
<td style='text-align: right;'>0.83</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>11,677</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Geometry</td>
<td style='text-align: right;'>0.75</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>67,945</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 8</td>
<td style='text-align: right;'>0.79</td>
<td style='text-align: right;'>0.01</td>
<td style='text-align: right;'>-0.09</td>
<td style='text-align: right;'>2,913</td>
</tr>
<tr>
<td style='text-align: right;'>Geometry</td>
<td style='text-align: right;'> Algebra II</td>
<td style='text-align: right;'>0.81</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>2,976</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Algebra I</td>
<td style='text-align: right;'>0.78</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.09</td>
<td style='text-align: right;'>104,058</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 7</td>
<td style='text-align: right;'>0.74</td>
<td style='text-align: right;'>0.01</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>1,476</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 8</td>
<td style='text-align: right;'>0.77</td>
<td style='text-align: right;'>0.01</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>5,509</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>Fall 2015 Algebra I</td>
<td style='text-align: right;'>0.71</td>
<td style='text-align: right;'>0.01</td>
<td style='text-align: right;'>-0.11</td>
<td style='text-align: right;'>1,101</td>
</tr>
<tr>
<td style='text-align: right;'>Integrated Math 1</td>
<td style='text-align: right;'> Mathematics Grade 7</td>
<td style='text-align: right;'>0.78</td>
<td style='text-align: right;'>0.01</td>
<td style='text-align: right;'>-0.10</td>
<td style='text-align: right;'>1,261</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'> Mathematics Grade 8</td>
<td style='text-align: right;'>0.75</td>
<td style='text-align: right;'>0.00</td>
<td style='text-align: right;'>-0.10</td>
<td style='text-align: right;'>12,528</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Integrated Math 2</td>
<td style='border-bottom: 2px solid grey; text-align: right;'> Integrated Math 1</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>0.72</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>0.00</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>-0.09</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>2,865</td>
</tr>
</tbody>
</table>



# SGP Results

In the following sections basic descriptive statistics from the 2016 analyses are provided, including the consortium-level mean and median growth percentiles.  Currently the PARCC consortium uses unadjusted cohort-referenced SGPs as the official student-level growth metric.  Descriptive statistics from the unadjusted and SIMEX corrected SGP results are both presented here.  The interested reader can find more in depth discussions of the SGP methodology in Appendix B of this report as well as other [available literature](https://github.com/CenterForAssessment/SGP_Resources/tree/master/articles), and information about the SIMEX measurement error correction methodology is available in recent academic articles [see @ShangVanIBet:2015].

## Unadjusted SGPs

Growth percentiles, being quantities associated with each individual student, can be easily summarized across numerous grouping indicators to provide summary results regarding growth.  The median and mean of a collection of growth percentiles are used as measures of central tendency that summarize the distribution as a single number.  With perfect data fit, we expect the consortium-wide median of all student growth percentiles in any grade to be 50 because the data are norm-referenced across all students in PARCC.  Median (and mean) growth percentiles well below 50 represent growth less than the consortium "average" and median growth percentiles well above 50 represent growth in excess of the PARCC "average".

To demonstrate the norm-referenced nature of the growth percentiles viewed at the consortium level, Tables 5 and  6 present the cohort-referenced growth percentile medians and means for the grade level and EOCT content areas respectively.


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='10' style='text-align: left;'>
**Table 5:** Spring 2016 Grade Level Median (Mean) Student Growth Percentile by Grade and Content Area.</td></tr>
<tr>
<th colspan='1' style='font-weight: 900; border-top: 2px solid grey; text-align: center;'></th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='8' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grades</th>
</tr>
<tr>
<th style='border-bottom: 1px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>4</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>5</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>6</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>7</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>8</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>9</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>10</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>11</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>ELA</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (50)</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Mathematics</td>
<td style='border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (50)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (50)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (50)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (50)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (50)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
</tr>
</tbody>
</table>


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='3' style='text-align: left;'>
**Table 6:** Spring 2016 EOCT Median and Mean Student Growth Percentile by Content Area.</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Median SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>Algebra I</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'>Algebra II</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'>Geometry</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>50.1</td>
</tr>
<tr>
<td style='text-align: right;'>Integrated Math 1</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>49.9</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Integrated Math 2</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>50</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>49.8</td>
</tr>
</tbody>
</table>

Based upon perfect model fit to the data, the median of all state growth percentiles in each grade by year by subject combination should be 50.  That is, in the conditional distributions, 50 percent of growth percentiles should be less than 50 and 50 percent should be greater than 50.  Deviations from 50 indicate imperfect model fit to the data.  Imperfect model fit can occur for a number of reasons, some due to issues with the data (e.g., floor and ceiling effects leading to a "bunching" up of the data) as well as issues due to the way that the SGP function fits the data.  The results in Tables 5 and 6 are close to perfect, with almost all values equal to 50.

The results are coarse in that they are aggregated across hundreds of thousands of students.  More refined fit analyses were presented in the Goodness-of-Fit section.  Depending upon feedback from Pearson, it may be desirable to tweak some operational parameters and attempt to improve fit even further.  The impact upon the operational results based on better fit is expected to be extremely minor.

It is important to note how, at the entire consortium level, the *norm-referenced* growth information returns little information on annual trends due to its norm-reference nature.  What the results indicate is that a typical (or average) student in the state demonstrates 50<sup>th</sup> percentile growth.  That is, "typical students" demonstrate "typical growth".  One benefit of the norm-referenced results follows when subgroups are examined (e.g., schools, district, demographic groups, etc.) Examining subgroups in terms of the mean or median of their student growth percentiles, it is then possible to investigate why some subgroups display lower/higher student growth than others.  Moreover, because the subgroup summary statistic (i.e., the median) is composed of many individual student growth percentiles, one can break out the result and further examine the distribution of individual results.  


## SIMEX Adjusted SGPs

The use of error-prone standardized test scores in statistical models can lead to numerous problems.  Understanding the effects of measurement error and correcting for it is particularly difficult in the SGP model given that it is based on non-parametric quantile regression.  Preliminary investigations suggest that the use of error-prone measures may lead SGP estimates to be inflated for students with high prior achievement and underestimated for students with lower prior achievement.  This bias at the individual student-level can translate to bias in aggregate measures (such as median and mean SGPs) when student sorting based on prior achievement exists at the level of aggregation (e.g.  classrooms or schools).  As a result, growth and prior achievement are (positively) correlated, giving schools and teachers with higher achieving students an undue advantage and disadvantaging those with lower achieving students [@ShangVanIBet:2015].  

Simulation-extrapolation (SIMEX) methods of correcting for measurement error induced bias in the SGP estimation has been proposed and tested in other states.  Descriptive statistics from these analyses are provided here and in the Goodness-of-Fit section.


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='10' style='text-align: left;'>
**Table 7:** SIMEX Corrected Grade Level Median (Mean) Student Growth Percentile by Grade and Content Area for Spring 2016</td></tr>
<tr>
<th colspan='1' style='font-weight: 900; border-top: 2px solid grey; text-align: center;'></th><th style='border-top: 2px solid grey;; border-bottom: hidden;'>&nbsp;</th>
<th colspan='8' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grades</th>
</tr>
<tr>
<th style='border-bottom: 1px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey;' colspan='1'>&nbsp;</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>4</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>5</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>6</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>7</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>8</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>9</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>10</th>
<th style='border-bottom: 1px solid grey; text-align: center;'>11</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>ELA</td>
<td style='' colspan='1'>&nbsp;</td>
<td style='text-align: right;'>50 (49.9)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (49.9)</td>
<td style='text-align: right;'>50 (50)</td>
<td style='text-align: right;'>50 (49.9)</td>
<td style='text-align: right;'>50 (49.9)</td>
<td style='text-align: right;'>50 (49.9)</td>
<td style='text-align: right;'>50 (50)</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Mathematics</td>
<td style='border-bottom: 2px solid grey;' colspan='1'>&nbsp;</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (49.9)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (49.9)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (49.9)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (49.9)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50 (49.9)</td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
</tr>
</tbody>
</table>



<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='3' style='text-align: left;'>
**Table 8:** SIMEX Corrected EOCT Median (Mean) Student Growth Percentile by Content Area for Spring 2016</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Content Area</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Median SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>Algebra I</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'>Algebra II</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>49.9</td>
</tr>
<tr>
<td style='text-align: right;'>Geometry</td>
<td style='text-align: center;'>50</td>
<td style='text-align: center;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'>Integrated Math 1</td>
<td style='text-align: center;'>49</td>
<td style='text-align: center;'>49.9</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'>Integrated Math 2</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>49</td>
<td style='border-bottom: 2px solid grey; text-align: center;'>50.0</td>
</tr>
</tbody>
</table>

A comparison of the unadjusted (Tables 5 and 6) and SIMEX corrected (Tables 7 and 8) shows very little difference in the medians and means.  This is not surprising as the majority of the growth percentiles for students in the middle of the prior score distributions change very little, and the larger changes that occur for students in the extremes of the prior score distributions tend to even out.  



## Group Level Results

Unlike when reporting SGPs at the individual level, when aggregating to the group level (e.g., school) the correlation between aggregate prior student achievement and aggregate growth is rarely zero. The correlation between prior student achievement and growth at the school level is a compelling descriptive statistic because it indicates whether students attending schools serving higher achieving students grow faster (on average) than those students attending schools serving lower achieving students. Results from previous state analyses show a correlation between prior achievement of students associated with a current school (quantified as percent at/above proficient) and the median SGP are typically between 0.1 and 0.3 (although higher numbers have been observed in some states as well). That is, these results indicate that on average, students attending schools serving lower achieving students tend to demonstrate less exemplary growth than those attending schools serving higher achieving students. Equivalently, based upon ordinary least squares (OLS) regression assumptions, the prior achievement level of students attending a school accounts for between 1 and 10 percent of the variability observed in student growth. There are no definitive numbers on what this correlation should be, but recent studies on value-added models show similar results [@MccaLock:2008].


###  States
In this section we aggregate test score and SGP results by state.  At present, district, school or other group identification has not been attached to the student records provided to the Center for Assessment.  Smaller group level analyses are therefore left to the individual consortium members to perform.  In addition to mean SGP values, mean prior test scores are given using both the IRT Theta and PARCC scale metrics.  This mean prior achievement value is given further context by providing percentile value it corresponds with in that test score distribution.  

Summary values are provided in the following tables only when a state has *1,000 students or greater* in a norm group.  A randomized (i.e. non-alphabetical) letter has been attached to each state in order to protect the identity of the member states.  As in previous tables of SGP results in this report, ELA and Mathematics results are disaggregated by grade level and EOCT Math tables are disaggregated by the most recent prior ensuring that all SGPs included in the summary statistics include only results from one analysis (norm group).  Tables for the Integrated Mathematics SGPs are not presented as only two states had any one cohort with greater than 1,000 students, and therefore presenting these tables may compromise state anonymity.




<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 9:** Spring 2016 Typical Prior Achievement and Growth by State: ELA</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grade</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>4</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>735.2</td>
<td style='text-align: right;'>-0.01</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>45.8</td>
<td style='text-align: right;'>45.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>737.2</td>
<td style='text-align: right;'> 0.05</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>47.6</td>
<td style='text-align: right;'>47.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>720.8</td>
<td style='text-align: right;'>-0.41</td>
<td style='text-align: right;'>34</td>
<td style='text-align: right;'>49.6</td>
<td style='text-align: right;'>50.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>736.0</td>
<td style='text-align: right;'> 0.01</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>48.4</td>
<td style='text-align: right;'>48.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>737.1</td>
<td style='text-align: right;'> 0.04</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>52.1</td>
<td style='text-align: right;'>52.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>750.2</td>
<td style='text-align: right;'> 0.41</td>
<td style='text-align: right;'>62</td>
<td style='text-align: right;'>54.1</td>
<td style='text-align: right;'>53.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>724.7</td>
<td style='text-align: right;'>-0.30</td>
<td style='text-align: right;'>38</td>
<td style='text-align: right;'>42.6</td>
<td style='text-align: right;'>43.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>743.5</td>
<td style='text-align: right;'> 0.22</td>
<td style='text-align: right;'>55</td>
<td style='text-align: right;'>57.2</td>
<td style='text-align: right;'>56.9</td>
</tr>
<tr>
<td style='text-align: right;'>5</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>740.8</td>
<td style='text-align: right;'> 0.00</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>45.1</td>
<td style='text-align: right;'>45.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>740.5</td>
<td style='text-align: right;'>-0.01</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>49.0</td>
<td style='text-align: right;'>49.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>727.1</td>
<td style='text-align: right;'>-0.45</td>
<td style='text-align: right;'>31</td>
<td style='text-align: right;'>52.7</td>
<td style='text-align: right;'>53.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>739.0</td>
<td style='text-align: right;'>-0.06</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>53.9</td>
<td style='text-align: right;'>54.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>742.1</td>
<td style='text-align: right;'> 0.04</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>50.4</td>
<td style='text-align: right;'>50.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>757.3</td>
<td style='text-align: right;'> 0.53</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>54.0</td>
<td style='text-align: right;'>53.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>727.7</td>
<td style='text-align: right;'>-0.43</td>
<td style='text-align: right;'>32</td>
<td style='text-align: right;'>49.2</td>
<td style='text-align: right;'>50.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>750.2</td>
<td style='text-align: right;'> 0.30</td>
<td style='text-align: right;'>58</td>
<td style='text-align: right;'>56.2</td>
<td style='text-align: right;'>55.9</td>
</tr>
<tr>
<td style='text-align: right;'>6</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>739.8</td>
<td style='text-align: right;'>-0.03</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>46.7</td>
<td style='text-align: right;'>46.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>740.0</td>
<td style='text-align: right;'>-0.02</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>47.5</td>
<td style='text-align: right;'>47.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>727.7</td>
<td style='text-align: right;'>-0.44</td>
<td style='text-align: right;'>32</td>
<td style='text-align: right;'>48.2</td>
<td style='text-align: right;'>49.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>738.2</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>50.0</td>
<td style='text-align: right;'>50.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>740.9</td>
<td style='text-align: right;'> 0.01</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>49.4</td>
<td style='text-align: right;'>49.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>754.6</td>
<td style='text-align: right;'> 0.48</td>
<td style='text-align: right;'>63</td>
<td style='text-align: right;'>56.3</td>
<td style='text-align: right;'>55.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>728.0</td>
<td style='text-align: right;'>-0.43</td>
<td style='text-align: right;'>33</td>
<td style='text-align: right;'>49.4</td>
<td style='text-align: right;'>50.4</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>H</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>750.2</td>
<td style='border-bottom: 2px solid grey; text-align: right;'> 0.33</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>58</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>55.0</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>54.5</td>
</tr>
</tbody>
</table>

<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 10:** Spring 2016 Typical Prior Achievement and Growth by State: ELA (<em>Continued</em>)</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grade</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>7</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>738.2</td>
<td style='text-align: right;'>-0.04</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>46.6</td>
<td style='text-align: right;'>46.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>738.0</td>
<td style='text-align: right;'>-0.04</td>
<td style='text-align: right;'>45</td>
<td style='text-align: right;'>48.6</td>
<td style='text-align: right;'>48.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>725.7</td>
<td style='text-align: right;'>-0.47</td>
<td style='text-align: right;'>31</td>
<td style='text-align: right;'>48.0</td>
<td style='text-align: right;'>49.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>736.6</td>
<td style='text-align: right;'>-0.09</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>50.0</td>
<td style='text-align: right;'>50.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>740.0</td>
<td style='text-align: right;'> 0.03</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>48.5</td>
<td style='text-align: right;'>48.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>753.8</td>
<td style='text-align: right;'> 0.51</td>
<td style='text-align: right;'>65</td>
<td style='text-align: right;'>54.1</td>
<td style='text-align: right;'>53.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>727.4</td>
<td style='text-align: right;'>-0.41</td>
<td style='text-align: right;'>33</td>
<td style='text-align: right;'>44.2</td>
<td style='text-align: right;'>45.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>748.1</td>
<td style='text-align: right;'> 0.31</td>
<td style='text-align: right;'>58</td>
<td style='text-align: right;'>57.1</td>
<td style='text-align: right;'>56.9</td>
</tr>
<tr>
<td style='text-align: right;'>8</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>739.6</td>
<td style='text-align: right;'>-0.01</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>46.9</td>
<td style='text-align: right;'>46.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>737.7</td>
<td style='text-align: right;'>-0.06</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>47.3</td>
<td style='text-align: right;'>47.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>725.0</td>
<td style='text-align: right;'>-0.44</td>
<td style='text-align: right;'>32</td>
<td style='text-align: right;'>51.2</td>
<td style='text-align: right;'>52.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>737.7</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>50.5</td>
<td style='text-align: right;'>50.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>740.2</td>
<td style='text-align: right;'> 0.01</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>49.3</td>
<td style='text-align: right;'>49.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>757.0</td>
<td style='text-align: right;'> 0.51</td>
<td style='text-align: right;'>64</td>
<td style='text-align: right;'>51.8</td>
<td style='text-align: right;'>50.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>722.5</td>
<td style='text-align: right;'>-0.51</td>
<td style='text-align: right;'>30</td>
<td style='text-align: right;'>51.7</td>
<td style='text-align: right;'>52.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>750.2</td>
<td style='text-align: right;'> 0.31</td>
<td style='text-align: right;'>57</td>
<td style='text-align: right;'>56.0</td>
<td style='text-align: right;'>55.6</td>
</tr>
<tr>
<td style='text-align: right;'>9</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>744.1</td>
<td style='text-align: right;'> 0.14</td>
<td style='text-align: right;'>50</td>
<td style='text-align: right;'>43.0</td>
<td style='text-align: right;'>42.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>725.4</td>
<td style='text-align: right;'>-0.41</td>
<td style='text-align: right;'>32</td>
<td style='text-align: right;'>45.9</td>
<td style='text-align: right;'>46.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>734.4</td>
<td style='text-align: right;'>-0.14</td>
<td style='text-align: right;'>40</td>
<td style='text-align: right;'>50.2</td>
<td style='text-align: right;'>50.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>739.4</td>
<td style='text-align: right;'> 0.00</td>
<td style='text-align: right;'>45</td>
<td style='text-align: right;'>49.8</td>
<td style='text-align: right;'>49.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>723.8</td>
<td style='text-align: right;'>-0.45</td>
<td style='text-align: right;'>30</td>
<td style='text-align: right;'>56.5</td>
<td style='text-align: right;'>57.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>749.4</td>
<td style='text-align: right;'> 0.29</td>
<td style='text-align: right;'>56</td>
<td style='text-align: right;'>56.2</td>
<td style='text-align: right;'>55.8</td>
</tr>
<tr>
<td style='text-align: right;'>10</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>738.5</td>
<td style='text-align: right;'> 0.04</td>
<td style='text-align: right;'>51</td>
<td style='text-align: right;'>29.6</td>
<td style='text-align: right;'>29.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>726.1</td>
<td style='text-align: right;'>-0.32</td>
<td style='text-align: right;'>39</td>
<td style='text-align: right;'>41.4</td>
<td style='text-align: right;'>41.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>734.0</td>
<td style='text-align: right;'>-0.09</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>42.9</td>
<td style='text-align: right;'>42.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>730.2</td>
<td style='text-align: right;'>-0.20</td>
<td style='text-align: right;'>43</td>
<td style='text-align: right;'>49.5</td>
<td style='text-align: right;'>49.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>740.0</td>
<td style='text-align: right;'> 0.09</td>
<td style='text-align: right;'>53</td>
<td style='text-align: right;'>52.5</td>
<td style='text-align: right;'>52.4</td>
</tr>
<tr>
<td style='text-align: right;'>11</td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>728.6</td>
<td style='text-align: right;'>-0.17</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>46.6</td>
<td style='text-align: right;'>46.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>732.2</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>53</td>
<td style='text-align: right;'>52.4</td>
<td style='text-align: right;'>52.3</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>H</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>729.3</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>-0.15</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50.1</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50.1</td>
</tr>
</tbody>
</table>




<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 11:** Spring 2016 Typical Prior Achievement and Growth by State: Mathematics</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grade</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>4</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>736.7</td>
<td style='text-align: right;'>-0.09</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>45.4</td>
<td style='text-align: right;'>45.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>737.0</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>52.3</td>
<td style='text-align: right;'>52.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>731.2</td>
<td style='text-align: right;'>-0.26</td>
<td style='text-align: right;'>41</td>
<td style='text-align: right;'>50.6</td>
<td style='text-align: right;'>51.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>736.9</td>
<td style='text-align: right;'>-0.08</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>50.4</td>
<td style='text-align: right;'>50.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>737.4</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>46.9</td>
<td style='text-align: right;'>46.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>751.0</td>
<td style='text-align: right;'> 0.36</td>
<td style='text-align: right;'>63</td>
<td style='text-align: right;'>56.5</td>
<td style='text-align: right;'>55.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>729.0</td>
<td style='text-align: right;'>-0.33</td>
<td style='text-align: right;'>38</td>
<td style='text-align: right;'>46.7</td>
<td style='text-align: right;'>47.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>745.6</td>
<td style='text-align: right;'> 0.19</td>
<td style='text-align: right;'>57</td>
<td style='text-align: right;'>55.7</td>
<td style='text-align: right;'>55.4</td>
</tr>
<tr>
<td style='text-align: right;'>5</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>732.6</td>
<td style='text-align: right;'>-0.17</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>48.1</td>
<td style='text-align: right;'>48.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>733.8</td>
<td style='text-align: right;'>-0.13</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>51.3</td>
<td style='text-align: right;'>51.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>729.7</td>
<td style='text-align: right;'>-0.27</td>
<td style='text-align: right;'>44</td>
<td style='text-align: right;'>47.4</td>
<td style='text-align: right;'>47.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>731.7</td>
<td style='text-align: right;'>-0.21</td>
<td style='text-align: right;'>46</td>
<td style='text-align: right;'>51.0</td>
<td style='text-align: right;'>51.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>734.1</td>
<td style='text-align: right;'>-0.12</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>47.2</td>
<td style='text-align: right;'>47.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>749.9</td>
<td style='text-align: right;'> 0.41</td>
<td style='text-align: right;'>68</td>
<td style='text-align: right;'>48.7</td>
<td style='text-align: right;'>47.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>724.7</td>
<td style='text-align: right;'>-0.44</td>
<td style='text-align: right;'>38</td>
<td style='text-align: right;'>50.8</td>
<td style='text-align: right;'>51.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>743.3</td>
<td style='text-align: right;'> 0.19</td>
<td style='text-align: right;'>60</td>
<td style='text-align: right;'>54.2</td>
<td style='text-align: right;'>53.8</td>
</tr>
<tr>
<td style='text-align: right;'>6</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>732.0</td>
<td style='text-align: right;'>-0.17</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>49.6</td>
<td style='text-align: right;'>49.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>733.2</td>
<td style='text-align: right;'>-0.13</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>50.7</td>
<td style='text-align: right;'>50.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>729.0</td>
<td style='text-align: right;'>-0.27</td>
<td style='text-align: right;'>43</td>
<td style='text-align: right;'>39.4</td>
<td style='text-align: right;'>39.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>730.5</td>
<td style='text-align: right;'>-0.22</td>
<td style='text-align: right;'>45</td>
<td style='text-align: right;'>49.9</td>
<td style='text-align: right;'>50.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>733.5</td>
<td style='text-align: right;'>-0.12</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>48.6</td>
<td style='text-align: right;'>48.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>748.1</td>
<td style='text-align: right;'> 0.39</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>52.8</td>
<td style='text-align: right;'>51.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>726.2</td>
<td style='text-align: right;'>-0.37</td>
<td style='text-align: right;'>40</td>
<td style='text-align: right;'>44.3</td>
<td style='text-align: right;'>44.8</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>H</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>743.8</td>
<td style='border-bottom: 2px solid grey; text-align: right;'> 0.24</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>61</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>51.7</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>51.0</td>
</tr>
</tbody>
</table>

<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 12:** Spring 2016 Typical Prior Achievement and Growth by State: Mathematics (<em>Continued</em>)</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Grade</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'>7</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>732.2</td>
<td style='text-align: right;'>-0.15</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>50.0</td>
<td style='text-align: right;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>727.6</td>
<td style='text-align: right;'>-0.31</td>
<td style='text-align: right;'>41</td>
<td style='text-align: right;'>50.9</td>
<td style='text-align: right;'>51.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>721.9</td>
<td style='text-align: right;'>-0.51</td>
<td style='text-align: right;'>34</td>
<td style='text-align: right;'>44.2</td>
<td style='text-align: right;'>44.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>729.7</td>
<td style='text-align: right;'>-0.24</td>
<td style='text-align: right;'>43</td>
<td style='text-align: right;'>52.2</td>
<td style='text-align: right;'>52.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>732.2</td>
<td style='text-align: right;'>-0.15</td>
<td style='text-align: right;'>47</td>
<td style='text-align: right;'>46.7</td>
<td style='text-align: right;'>46.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>748.5</td>
<td style='text-align: right;'> 0.42</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>50.8</td>
<td style='text-align: right;'>49.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>724.1</td>
<td style='text-align: right;'>-0.43</td>
<td style='text-align: right;'>36</td>
<td style='text-align: right;'>46.1</td>
<td style='text-align: right;'>46.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>740.4</td>
<td style='text-align: right;'> 0.14</td>
<td style='text-align: right;'>57</td>
<td style='text-align: right;'>52.2</td>
<td style='text-align: right;'>51.6</td>
</tr>
<tr>
<td style='text-align: right;'>8</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>733.2</td>
<td style='text-align: right;'>-0.06</td>
<td style='text-align: right;'>48</td>
<td style='text-align: right;'>49.4</td>
<td style='text-align: right;'>48.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>719.6</td>
<td style='text-align: right;'>-0.59</td>
<td style='text-align: right;'>30</td>
<td style='text-align: right;'>48.0</td>
<td style='text-align: right;'>48.9</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>718.3</td>
<td style='text-align: right;'>-0.65</td>
<td style='text-align: right;'>28</td>
<td style='text-align: right;'>45.3</td>
<td style='text-align: right;'>46.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>722.3</td>
<td style='text-align: right;'>-0.49</td>
<td style='text-align: right;'>33</td>
<td style='text-align: right;'>46.6</td>
<td style='text-align: right;'>47.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>726.0</td>
<td style='text-align: right;'>-0.34</td>
<td style='text-align: right;'>38</td>
<td style='text-align: right;'>47.4</td>
<td style='text-align: right;'>47.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>743.7</td>
<td style='text-align: right;'> 0.35</td>
<td style='text-align: right;'>63</td>
<td style='text-align: right;'>56.3</td>
<td style='text-align: right;'>55.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>717.2</td>
<td style='text-align: right;'>-0.68</td>
<td style='text-align: right;'>27</td>
<td style='text-align: right;'>48.8</td>
<td style='text-align: right;'>50.1</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>H</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>728.1</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>-0.26</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>41</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>52.0</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>51.9</td>
</tr>
</tbody>
</table>



<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 13:** Spring 2016 Typical Prior Achievement and Growth by State: Algebra I</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Most Recent Prior</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'> Math Grade 6</td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>769.2</td>
<td style='text-align: right;'> 1.14</td>
<td style='text-align: right;'>86</td>
<td style='text-align: right;'>55.1</td>
<td style='text-align: right;'>56.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>780.8</td>
<td style='text-align: right;'> 1.55</td>
<td style='text-align: right;'>93</td>
<td style='text-align: right;'>36.1</td>
<td style='text-align: right;'>35.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>791.0</td>
<td style='text-align: right;'> 1.91</td>
<td style='text-align: right;'>97</td>
<td style='text-align: right;'>52.7</td>
<td style='text-align: right;'>51.3</td>
</tr>
<tr>
<td style='text-align: right;'> Math Grade 7</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>753.2</td>
<td style='text-align: right;'> 0.72</td>
<td style='text-align: right;'>75</td>
<td style='text-align: right;'>48.6</td>
<td style='text-align: right;'>48.7</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>745.9</td>
<td style='text-align: right;'> 0.44</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>56.1</td>
<td style='text-align: right;'>57.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>757.0</td>
<td style='text-align: right;'> 0.87</td>
<td style='text-align: right;'>79</td>
<td style='text-align: right;'>47.3</td>
<td style='text-align: right;'>47.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>756.7</td>
<td style='text-align: right;'> 0.86</td>
<td style='text-align: right;'>78</td>
<td style='text-align: right;'>43.2</td>
<td style='text-align: right;'>42.8</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>F</td>
<td style='text-align: right;'>768.0</td>
<td style='text-align: right;'> 1.30</td>
<td style='text-align: right;'>88</td>
<td style='text-align: right;'>53.4</td>
<td style='text-align: right;'>52.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>745.7</td>
<td style='text-align: right;'> 0.43</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>43.7</td>
<td style='text-align: right;'>44.5</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>760.8</td>
<td style='text-align: right;'> 1.02</td>
<td style='text-align: right;'>82</td>
<td style='text-align: right;'>49.4</td>
<td style='text-align: right;'>48.7</td>
</tr>
<tr>
<td style='text-align: right;'> Math Grade 8</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>724.8</td>
<td style='text-align: right;'>-0.11</td>
<td style='text-align: right;'>52</td>
<td style='text-align: right;'>48.8</td>
<td style='text-align: right;'>48.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>713.8</td>
<td style='text-align: right;'>-0.44</td>
<td style='text-align: right;'>39</td>
<td style='text-align: right;'>53.6</td>
<td style='text-align: right;'>54.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>709.2</td>
<td style='text-align: right;'>-0.59</td>
<td style='text-align: right;'>33</td>
<td style='text-align: right;'>40.7</td>
<td style='text-align: right;'>41.6</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>715.3</td>
<td style='text-align: right;'>-0.39</td>
<td style='text-align: right;'>40</td>
<td style='text-align: right;'>48.8</td>
<td style='text-align: right;'>49.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>718.1</td>
<td style='text-align: right;'>-0.31</td>
<td style='text-align: right;'>45</td>
<td style='text-align: right;'>47.8</td>
<td style='text-align: right;'>48.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>709.9</td>
<td style='text-align: right;'>-0.56</td>
<td style='text-align: right;'>34</td>
<td style='text-align: right;'>49.2</td>
<td style='text-align: right;'>50.3</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>H</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>727.3</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>-0.03</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>55</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50.9</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>50.1</td>
</tr>
</tbody>
</table>


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 14:** Spring 2016 Typical Prior Achievement and Growth by State: Algebra II</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Most Recent Prior</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'> Algebra I</td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>744.0</td>
<td style='text-align: right;'> 0.35</td>
<td style='text-align: right;'>58</td>
<td style='text-align: right;'>50.0</td>
<td style='text-align: right;'>50.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>726.4</td>
<td style='text-align: right;'>-0.24</td>
<td style='text-align: right;'>39</td>
<td style='text-align: right;'>46.4</td>
<td style='text-align: right;'>48.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>752.1</td>
<td style='text-align: right;'> 0.61</td>
<td style='text-align: right;'>66</td>
<td style='text-align: right;'>50.6</td>
<td style='text-align: right;'>50.3</td>
</tr>
<tr>
<td style='text-align: right;'> Geometry</td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>767.8</td>
<td style='text-align: right;'> 1.44</td>
<td style='text-align: right;'>92</td>
<td style='text-align: right;'>41.7</td>
<td style='text-align: right;'>38.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>726.1</td>
<td style='text-align: right;'>-0.21</td>
<td style='text-align: right;'>49</td>
<td style='text-align: right;'>48.1</td>
<td style='text-align: right;'>48.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>729.9</td>
<td style='text-align: right;'>-0.07</td>
<td style='text-align: right;'>54</td>
<td style='text-align: right;'>50.8</td>
<td style='text-align: right;'>50.7</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'> Math Grade 8</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>B</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>786.6</td>
<td style='border-bottom: 2px solid grey; text-align: right;'> 1.74</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>98</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>55.0</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>54.6</td>
</tr>
</tbody>
</table>


<table class='gmisc_table breakboth' style='border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;' >
<thead>
<tr><td colspan='7' style='text-align: left;'>
**Table 15:** Spring 2016 Typical Prior Achievement and Growth by State: Geometry</td></tr>
<tr>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Most Recent Prior</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>State</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Scale Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean Prior
 Theta Score</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>PARCC %ile
 (Mean Prior Theta)</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SGP</th>
<th style='border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;'>Mean SIMEX</th>
</tr>
</thead>
<tbody>
<tr>
<td style='text-align: right;'> Algebra I</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>729.5</td>
<td style='text-align: right;'>-0.14</td>
<td style='text-align: right;'>43</td>
<td style='text-align: right;'>40.1</td>
<td style='text-align: right;'>40.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>B</td>
<td style='text-align: right;'>750.0</td>
<td style='text-align: right;'> 0.54</td>
<td style='text-align: right;'>64</td>
<td style='text-align: right;'>55.0</td>
<td style='text-align: right;'>54.3</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>C</td>
<td style='text-align: right;'>719.3</td>
<td style='text-align: right;'>-0.48</td>
<td style='text-align: right;'>32</td>
<td style='text-align: right;'>39.0</td>
<td style='text-align: right;'>40.1</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>D</td>
<td style='text-align: right;'>729.1</td>
<td style='text-align: right;'>-0.16</td>
<td style='text-align: right;'>42</td>
<td style='text-align: right;'>45.1</td>
<td style='text-align: right;'>45.4</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>E</td>
<td style='text-align: right;'>765.7</td>
<td style='text-align: right;'> 1.06</td>
<td style='text-align: right;'>78</td>
<td style='text-align: right;'>52.5</td>
<td style='text-align: right;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>G</td>
<td style='text-align: right;'>725.1</td>
<td style='text-align: right;'>-0.28</td>
<td style='text-align: right;'>38</td>
<td style='text-align: right;'>49.3</td>
<td style='text-align: right;'>50.2</td>
</tr>
<tr>
<td style='text-align: right;'></td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>737.9</td>
<td style='text-align: right;'> 0.14</td>
<td style='text-align: right;'>52</td>
<td style='text-align: right;'>51.0</td>
<td style='text-align: right;'>50.8</td>
</tr>
<tr>
<td style='text-align: right;'> Algebra II</td>
<td style='text-align: right;'>H</td>
<td style='text-align: right;'>728.5</td>
<td style='text-align: right;'> 0.22</td>
<td style='text-align: right;'>54</td>
<td style='text-align: right;'>50.4</td>
<td style='text-align: right;'>50.0</td>
</tr>
<tr>
<td style='text-align: right;'> Math Grade 8</td>
<td style='text-align: right;'>A</td>
<td style='text-align: right;'>762.6</td>
<td style='text-align: right;'> 1.02</td>
<td style='text-align: right;'>89</td>
<td style='text-align: right;'>56.7</td>
<td style='text-align: right;'>56.3</td>
</tr>
<tr>
<td style='border-bottom: 2px solid grey; text-align: right;'></td>
<td style='border-bottom: 2px solid grey; text-align: right;'>E</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>757.0</td>
<td style='border-bottom: 2px solid grey; text-align: right;'> 0.86</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>85</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>49.9</td>
<td style='border-bottom: 2px solid grey; text-align: right;'>49.7</td>
</tr>
</tbody>
</table>



# References
