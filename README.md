This Folder
===========

This folder contains the following:
- SamCraig.pdf - the midterm paper explaining the urchins
- Stocks - a folder containing the code for the stock preparer, as well as
  raw stock data for the past 20 years for the Dow Jones
- Combiner - a folder containing the code for the combiner
- Generator - a folder containing the code for the generator
- Grapher - a folder containing the code for the grapher
- Output - a folder containing all output generated by the sample combiner files
- CombinerFiles - a folder containing all of the combiner files I used to generate
  my output

Creating an Urchin
==================

Setup
-----

Before an urchin is made, there are some Ruby libraries used in stock preparation
and they should be installed.
To do this, enter into the `Stocks` directory and run `bundle install`.

Process
-------

To create an urchin, you will need to run the combiner on some combiner file.
First, note that all of these components are written like shell programs,
and thus they receive input in stdin and give output to stdout.
So, the simplest command to create an urchin would be:
`Combiner/combiner.rb -c < CombinerFiles/years/2018.combiner > my_urchin.eps`

Feel free to try this with any of the provided combiner files.
You could also make your own combiner file, either by hand or with the generator.
First, the format of a combiner file is that each line becomes a leg of the urchin
and each line is the command-line arguments provided to the stock preparer.
The stock preparer accepts a year (-y), month (-m), and day (-d).
The year and month must both be provided, but the day is an optional argument that
allows offsetting the month - for example, -d 3 would start each month on the
third day of the month.
None of my example urchins used the day parameter, but feel free to have at it!

The generator makes creation of combiner files easy.
For instance, to create the 2018 combiner file above, you can run:
`Generator/generator.rb -y 2018`.
You can also run it with a month argument:
`Generator/generator.rb -m 8`
And to either of these you can add a day argument (-d) that will offset
each leg by a number of days.

Note that the combiner has a -c option provided in the example command.
This activates cones mode, which restricts intersections of legs of the
urchin.
Remove the argument to turn it off, but that will result in some crazy-looking
urchins.

While the stock preparer and grapher are more so auxiliary utilities,
you can use them to produce a graph of the Dow Jones if you would like.
For example:
`Stocks/prepare.rb -y 2018 -m 1 | Grapher/grapher.rb`
The grapher will graph whatever you give it as long as it is a valid format.

Have fun creating urchins!
