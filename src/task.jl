"""
Text of the instructions given to participants before the scan. This is especially
important in context of resting state fMRI and distinguishing between eyes open and
eyes closed paradigms.
"""
@defprop Instructions{:instructions}::String

"""
URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term.
"""
@defprop CogAtlasID{:cog_atlas_id}::String

"""
URL of the corresponding [CogPO](http://www.cogpo.org/) term.
"""
@defprop CogPOID{:cog_poid}::String

"""
    TaskMetadata

* `name::String`: Name of the task. No two tasks should have the same name. Task
  label (task-) included in the file name is derived from this field by removing
  all non alphanumeric ([a-zA-Z0-9]) characters. For example task name faces n-back
  will corresponds to task label facesnback. A RECOMMENDED convention is to name
  resting state task using labels beginning with rest. Corresponds to BIDS "TaskName".
* `task_description::String`: Longer description of the task. Corresponds to BIDS
  "TaskDescription".
* `instructions::String`: Text of the instructions given to participants before the scan.
  This is especially important in context of resting state fMRI and distinguishing between
  eyes open and eyes closed paradigms. Corresponds to BIDS "Instructions".
* `cog_atlas_id::String`: URL of the corresponding [Cognitive Atlas Task](https://www.cognitiveatlas.org/) term. Corresponds to BIDS "CogAtlasID".
* `cog_poid::String`: URL of the corresponding [CogPO](http://www.cogpo.org/) term. Corresponds to BIDS "CogPOID".
* `properties::AbstractMetadata`: additional task metadata.

"""
mutable struct TaskMetadata{M} <: AbstractMetadata{M}
    task_name::String
    task_description::String
    instructions::String
    cog_atlas_id::String
    cog_poid::String
    metadata::M
end

@assignprops(
    TaskMetadata,
    name => Name,
    metadata => DictExtension(
                    CogAtlasID,
                    CogPOID,
                    Description,
                    DeviceSerialNumber,
                    InstitutionAddress
                    InstitutionName,
                    Instructions,
                    Manufacturer,
                    ManufacturerModelName,
                    SoftwareVersions
                   )
)

