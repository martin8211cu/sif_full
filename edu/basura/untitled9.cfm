<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<cfdump var="#form#">
<!---
 onSubmit="javascript: return k();"
--->
<form name="form1" method="post" action="untitled9.cfm">
  <input type="text" name="textfield" onKeyDown="javascript: return p(this, event);">
  <input type="submit" name="Submit" value="Submit">
</form>
<script language="JavaScript" type="text/javascript">
	function k() {
		document.form1.onsubmit = p;
		alert('k');
		return false;
	}

	function p(txtbox, e) {
		//var demoObj = document.form1;
		//demoObj.addEventListener("keydown", k, true);
		alert("p");
		return false;
        var keycode;
        var keyShift = false;
        var keyCtrl = false;
        var keyAlt = false;
        if (window.event)
        {
          keycode = window.event.keyCode;
          keyShift = window.event.shiftKey;
          keyCtrl = window.event.ctrlKey;
          keyAlt = window.event.altKey;
        } else {
			  if (e) {
			  	  keycode = e.which;
				  if (e.modifiers)
				  {
					keyShift = e.modifiers & e.SHIFT_MASK;
					keyCtrl = e.modifiers & e.CONTROL_MASK;
					keyAlt = e.modifiers & Event.ALT_MASK;
				  }
				  else
				  {
					keyShift = e.shiftKey;
					keyCtrl = e.ctrlKey;
					keyAlt = e.altKey;
				  }
				}
				else {
					return false;
				}
		}
		alert(keycode);
		return false;


        if (keycode == 46) {
		  return true;
		 }

        if (keycode == 13) {
			return false;
		}
	}

/*
	function init() {
	  demoObj = document.form1;
	  demoObj.addEventListener("keydown", k, true);
	}

	onload = init;
*/
</script>
<!---
<DIV ID="demoDiv" STYLE="position:relative; left:100px; top:20px; width:120px; 
height:25px; color:blue; background-color:yellow;">Mouse over me!</DIV>
<SCRIPT LANGUAGE="JavaScript">
<!--
var demoObj;

function init() {
  demoObj = document.getElementById("demoDiv");
  demoObj.addEventListener("mouseover", colorItTan, false);
  demoObj.addEventListener("mouseout", colorItYellow, false);
}

function colorItTan(e) {
  demoObj.style.backgroundColor = "tan";
  window.status = e.type;
}

function colorItYellow(e) {
  demoObj.style.backgroundColor = "yellow";
  window.status = e.type;
}

onload = init; 
// -->
</SCRIPT>
--->
</body>
</html>
