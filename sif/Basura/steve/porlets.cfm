<cfparam name="Attributes.marcar" type="boolean">

<script language="javascript1.2" type="text/javascript">
	function fnMarcar(m) {
		var f = document.fForm.elements;
		for (var i=0;i<=f.length;i++) {
			if (f[i].type == 'checkbox') {
				f[i].checked = m;
			}
		}
	}
</script>

<form name="fForm" action="" method="post">
	<input type="checkbox" name="chk1"> Check1<br>
	<input type="checkbox" name="chk2"> Check2<br>
	<input type="checkbox" name="chk3"> Check3<br>
	<input type="button" name="btnMarcar" value="Marcar"
		onClick="javascript:fnMarcar(<cfoutput>#Attributes.marcar#</cfoutput>)">
</form>