<script language="javascript1.2" type="text/javascript">
	function isPhoneNumber(s) {
		 rePhoneNumber = new RegExp(/^\([1-9]\d{2}\)\s?\d{3}\-\d{4}$/);	 
		 //rePhoneNumber = new RegExp(/^\d{3}\-\d{2}\-\d{2}$/);	 		 
		 if (!rePhoneNumber.test(s)) {
			  alert("El teléfono debe tener el siguiente formato: (555) 555-1234");
			  return false;
		 }
		return true;
	}
	alert(isPhoneNumber('(555) 555-1234'));	
</script>