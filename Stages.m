classdef Stages
    enumeration
        Import, HistogramEqualization, PowerLaw, UnsharpMasking
    end
    methods
        function tf = canApplyHistogramEqualization(obj)
            tf = (obj == Stages.Import...
                || obj == Stages.HistogramEqualization); 
        end
        function tf = canApplyPowerLaw(obj)
            tf = (obj == Stages.Import...
                || obj == Stages.HistogramEqualization...
                || obj == Stages.PowerLaw); 
        end
        function tf = canApplyUnsharpMasking(obj)
            tf = (obj == Stages.Import...
                || obj == Stages.HistogramEqualization...
                || obj == Stages.PowerLaw...
                || obj == Stages. UnsharpMasking); 
        end
        
    end
end

