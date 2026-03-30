class WfActivity {
	var ActivityId:Number;
	var Name:String;
	var Description:String;
	var Documentation:String;
	var SymbolData:String;
	var ReadOnly:Boolean;
	var NotifyPartBefore:Boolean;
	var NotifySubjAfter:Boolean;
	
	function WfActivity(aActivityId:Number,
						aName:String,
						aDescription:String,
						aDocumentation:String,
						aSymbolData:String,
						aReadOnly:Boolean,
						aNotifyPartBefore:Boolean,
						aNotifySubjAfter:Boolean
	) {
		ActivityId       = aActivityId;
		Name             = aName;
		Description      = aDescription;
		Documentation    = aDocumentation;
		SymbolData       = aSymbolData;
		ReadOnly         = aReadOnly;
		NotifyPartBefore = aNotifyPartBefore;
		NotifySubjAfter  = aNotifySubjAfter;
	}
	
	static var updateURL:String='flash_activity_update.cfm';
	
	static function update() {
		var my_lv = new LoadVars();
		var out_lv = new LoadVars();
		my_lv.sendAndLoad(updateURL,out_lv,'POST');
	}
}





