public class DraupHiringSortWrapper implements Comparable{
    
    @AuraEnabled public string hiringData;
    @AuraEnabled public Integer counter;
    
     public DraupHiringSortWrapper(string hiringData, Integer counter) 
    {
        this.hiringData = hiringData;
        //System.debug(' hiringData ' + hiringData);
        this.counter = counter;
        //System.debug(' counter '+ counter);
    }
    
    public Integer compareTo(Object other) {
        // for descending order
        DraupHiringSortWrapper ds = (DraupHiringSortWrapper)other;
        //system.debug('counter*'+counter+'other*'+ds.counter);
         if (counter == ds.counter) return 0;
        if (counter < ds.counter) return 1;
        return -1;        
        
    }

}