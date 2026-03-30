<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
<script language="JavaScript" type="text/javascript">
	function k() {
		return false;
	}
	
	function p(e) {
		alert(e.which);
		if (e.which == 13) {
			e.which = 0;
			document.form1.onsubmit = k;
		}
	} 
</script>

<cfdump var="#Form#">
<form name="form1" method="post" action="" onKeyPress="javascript: return p(event);">
  <input type="text" name="textfield">
  <input type="button" name="Button" value="Button" onClick="javascript: this.form.submit();">
  <div style="width: 500px; height: 100%; overflow: auto">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td nowrap>
		kdkjf lksjadf lka  alkjadslfjasldjfla sdjflaksjdflasdjlfkajefjasdlf j dsdalkf jasldjfalkjfalk las lsdjf lsdjflsak jlasdalsdjf alskjflkasdj lkfjd lkjafsldj alflkadlkf jalkfjalsdj flksajd fasdlf jadslkfjaslkfjalsdjfasdllasd ldsa lkasjf lsadjflksajdf aslfdalsdjf alksjfalsd jasldjfasld flasd alsdfj
		</td>
	  </tr>
	</table>
  </div>
</form>
</body>
</html>
