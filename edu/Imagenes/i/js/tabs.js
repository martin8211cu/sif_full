function setClassName(name, className)
{
	var obj = document.all ?
		document.all[name] : document.getElementById(name);
	if (obj == null)
		return false;
	obj.className = className;
	return (obj.className == className);
}

function setActiveTab(t, pfx)
{
	// iterar tab_title_* y tab_body_*
	
	if (pfx == null) {
		pfx = "tab";
	}
	
	var i = 0;
	while (i++ < 100) {
		if (!setClassName(pfx + "_title_" + i, i == t ? "tab-title-select" : "tab-title-normal"))
			break;
		if (!setClassName(pfx + "_body_" + i,  i == t ? "tab-body-select"  : "tab-body-normal" ))
			break;
	}
}
