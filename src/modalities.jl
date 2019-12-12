
struct T1WeightedImage <: AnatomicalImage end
const T1w = T1Weighted()
modality_label(::T1WeightedImage) = "T1w"

struct T2WeightedImage <: AnatomicalImage end
const T2w = T2WeightedImage()
modality_label(::T2WeightedImage) = "T2w"

struct T1RhoMapImage <: AnatomicalImage end
const T1RhoMap = T1RhoMapImage()
modality_label(::T1RhoMapImage) = "T1rho"

struct T1MapImage <: AnatomicalImage end
const T1Map = T1MapImage()
modality_label(::T1MapImage) = "T1map"

struct T2MapImage <: AnatomicalImage end
const T2Map = T2MapImage()
modality_label(::T2MapImage) = "T2map"

struct T2StarImage <: AnatomicalImage end
const T2Star = T2StarImage()
modality_label(::T2StarImage) = "T2star"

struct FastLowAngleShot <: AnatomicalImage end
const FLASH = FastLowAngleShot()
modality_label(::FLASH) = "FLASH"

struct FluidAttenuatedInversionRecovery <: AnatomicalImage end
const FLAIR = FluidAttenuatedInversionRecovery()
modality_label(::FLAIR) = "FLAIR"

struct ProtonDensity <: AnatomicalImage end
const PD = ProtonDensity()
modality_label(::ProtonDensity) = "PD"

struct ProtonDensityMap <: AnatomicalImage end
const PDMap = ProtonDensityMap()
modality_label(::ProtonDensityMap) = "PDmap"

struct CombinedPDT2 <: AnatomicalImage end
const PDT2 = CombinedPDT2()
modalitylabel(::CombinedPDT2) = "PDT2"

struct InplaneT1Image <: AnatomicalImage end
const InplaneT1 = InplaneT1Image()
modality_label(::InplaneT1) = "inplaneT1"

struct InplaneT2Image <: AnatomicalImage end
const InplaneT2 = InplaneT2Image()
modality_label(::InplaneT2) = "inplaneT2"

struct Angiography <: AnatomicalImage end
modality_label(::Angiography) = "angio"

struct DefaceMaskImage <: AnatomicalImage end
const DefaceMask = DefaceMaskImage()


###
### FunctionalImage
###
abstract type FunctionalImage end

struct BloodOxygenLevelDependent <: FunctionalImage end
const BOLD = BloodOxygenLevelDependent()
modality_label(::BloodOxygenLevelDependent) = "bold"

struct CerebralBloodVolume <: FunctionalImage end
const CBV = CerebralBloodVolume()
modality_label(::CerebralBloodVolume) = "cbv"

struct PhaseImage <: FunctionalImage end
const Phase = PhaseImage()
modality_label(::PhaseImage) = "phase"

struct SingleBandReferenceImage <: FunctionalImage end
const SBEP = SingleBandReferenceImage()


###
### FunctionalMap
###
abstract type FunctionalMap end

struct PhaseDifference <: FunctionalMap end
const PhaseDiff = PhaseDifference()

struct Phase1Map <: FunctionalMap end
const Phase1 = Phase1Map()

struct Phase2Map <: FunctionalMap end
const Phase2 = Phase2Map()

struct Magnitude1Map <: FunctionalMap end
const Magnitude1 = Phase1Map()

struct Magnitude2Map <: FunctionalMap end
const Magnitude2 = Phase2Map()

struct FieldMapImage <: FunctionalMap end
const FieldMap = FieldMapImage()

struct SpinEchoEPI <: FunctionalMap end
const SEEPI = SpinEchoEPI

###
### DiffusionWeightedImage
###
struct DiffusionWeightedImage end
const DWI = DiffusionWeightedImage()

struct BVector end
const BVec = BVector()

struct BValues end
const BVal = BValues()

###
### Electrode acquired modalities
###
struct Magnetoencephalogram <: FunctionalImage end
const MEG = Magnetoencephalography()

struct Electroencephalogram <: FunctionalImage end
const EEG = Electroencephologram()

struct InvasiveElectroencephalogram <: FunctionalImage end
const iEEG = InvasiveElectroencephalogram()

struct Electrocorticogram <: Electrophysiology end
const ECoG = Electrocorticogram()

struct Electrocardiogram <: Electrophysiology end
const ECG = Electrocardiogram()

struct Electrooculogram <: Electrophysiology end
const EOG = Electrooculogram()

struct Electromyogram <: Electrophysiology end
const EMG = Electromyogram()

#=
abstract type AnatomicalImage <: Imaging end

abstract type CellularImage <: Imaging end

"""
    B0 Map
"""
struct B0MapImage <: AnatomicalImage end
const B0Map = B0MapImage()

"""
    B1 Map
"""
struct B1MapImage <: AnatomicalImage end
const B1Map = B1MapImage()

"""
    Fast Imaging with Steady-state free Precision
"""
struct FastImagingwithSteadyStateFreePrecission <: FunctionalMRI end
const FISP = FastImagingwithSteadyStateFreePrecission()

"""
    Magnetization Prepared Rapid Acquisition With Gradient Echo (MPRAGE)
"""
struct MagnetizationPreparedRapidAcquisitionWithGradientEcho <: AnatomicalImage end
const MPRAGE = MagnetizationPreparedRapidAcquisitionWithGradientEcho()

"""
    Fast Spoiled Gradient Echo (FSPGR)
"""
struct FastSpoiledGradientEcho <: AnatomicalImage end
const FSPGR = FastSpoiledGradientEcho()

"""
    RapidAcquisitionWithRefocusedEchoes
"""
struct RapidAcquisitionWithRefocusedEchoes <: AnatomicalImage end
const RARE = RapidAcquisitionWithRefocusedEchoes()
const TurboSpinEcho = RARE
const FastSpinEcho = RARE

struct SusceptibilityWeightedImaging <: AnatomicalImage end
const SWI = SusceptibilityWeightedImaging()
modalitylabel(::SWI) = "SWImagandphase"

struct SingleShellDiffusionWeightedImage <: AnatomicalImage end
const SSDWI = SingleShellDiffusionWeightedImage()

struct MultiShellDiffusionWeightedImage <: AnatomicalImage end
const MSDWI = SingleShellDiffusionWeightedImage()

"""
    XRay

X-Ray
"""
abstract type XRayImage <: AnatomicalImage end
const XRay = XRayImage()


"""
    ComputedTomography

Computed tomography (CT)
"""
struct ComputedTomography <: AnatomicalImage end
const CT = ComputedTomography()

"""
    PositronEmissionTomography (PET)

Positron Emission Tomography. Most often used with X-ray but may be used with
MRI.
"""
struct PositronEmissionTomography <: AnatomicalImage end
const PET = PositronEmissionTomography()

###
### functional
###

"""
    Task Function MRI
"""
struct TaskFunctionalMRI <: FunctionalMRI end
const TaskfMRI = TaskFunctionalMRI()

"""
    RestingStateFMRI

Resting state functional magnetic resonance imaging modality (rsfMRI)
"""
struct RestingStateFunctionalMRI <: FunctionalMRI end
const rsFMRI = RestingStateFunctionalMRI()

"""
    Arterial Spin Labelling (ASL)
"""
struct ArterialSpinLabelling <: FunctionalMRI end
const ASLImage = ArterialSpinLabelling

"""
    Pseudo-continuous Arterial Spin Labelling
"""
struct PseudoContinuousArterialSpinLabelling <: FunctionalMRI end
const pCASL = PseudoContinuousArterialSpinLabelling()

abstract type CellularImage <: Imaging end

=#
