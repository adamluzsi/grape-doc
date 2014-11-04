Grape-Doc
========

### Description

It's a Grape documentation generator for lazy developers. 
The main goal is to make as clean and usefull documetation as possible for 3. party developers to your application without sharing anything from the code.

The Documentation generator it self is a little evil because it not force but really count on it,
that you make test for your api endpoints. For now it's all based on rack-test,
but support will be given for other testing frameworks too.

#### Install

    $ gem install grape-doc
  
#### Gemfile

    gem 'grape-doc'

#### Simple Use

```ruby

    GrapeDoc.generate
    #> this will create an api_doc.html in the project_folder/doc
    
```

I Would suggest run minitests firts,
with including all the test in the test folder that touch anything with your grape api classes.
Because a rack-test-poc , there will be generated yaml files in the test/poc folder

#### Complex Use

```ruby

    GrapeDoc.generate   format: 'redmine', # or textile, or html
                        path: File.join(__dir__,'..........')
                        

```
   
well that was complex! right?

#### After words

I would strongly suggest using Grape build in desc method for api endpoints,
and define every paramteres ahead, so they will be included in the documentation,
and validated on request!
