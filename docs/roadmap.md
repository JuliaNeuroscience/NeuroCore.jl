# Roadmap for JuliaNeuroscience

The following document begins by exploring the conceptual goals that the JuliaNeuroscience organization is intended to address. It further breaks down each goal until arriving at the technical details that must be addressed to meet each goal. The motivation for beginning this project will be detailed elsewhere.

## Goals

The overall goal of development within JuliaNeuroscience is to provide a set of computational tools for interacting with neuroscience data that bridges the numerous fields that contribute to its advancement. This will be largely accomplished by using common methods and types whenever possible to refer to similar concepts.

### Common data types

#### The Array
Julia benefits enormously from having a common interface to customizable arrays and using the `AbstractArray` interface instantly allows us access to cutting edge algorithms.


### Obtain Data

Neuroscience data takes numerous forms (MRI, EEG, MEG, neuron recordings, neuronal population simulations, etc.). The most basic possible unit of this data can often be conceptualized as an array.

The specific aims that contribute to this endeavor may be best understand in relation to the same components that contribute to most computational data science projects.

### Analyze Data

For example, many types of neuroscience data have a time or frequency component.
Time and frequency are common measures nearly all types of neuroscience data, excluding structural data with no time component. 

### Clean and Process Data


### Visualize Data

### Report and Share Findings.


1. Retrieve neuroscience related data (e.g., )
2. Data cleaning and processing (field registration, signal filtering, etc.)
3. Statistical analysis of processed

## Not Goals
The focus of these tools is intended to be pragmatic and does not preclude the use of existing tools.
