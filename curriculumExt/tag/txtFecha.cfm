<cfif not Session.javascript_txtFecha>
  <cfset Session.javascript_txtFecha=true>
  <script language="JavaScript" src="../js/calendar.js"></script>
  <script language="JavaScript" src="../js/utilesMonto.js"></script>
  <script language="JavaScript">
    function onkeypressdatetime(txtFecha, e)
	{
        var keycode;
		var value = txtFecha.value;
        if (window.event)
          keycode = window.event.keyCode;
        else if (e)
          keycode = e.which;
        else
          return true;

        if (((keycode>=47) && (keycode<58) ) || (keycode==8))
          return true;
        else
          return false;
	}
  </script>
</cfif>
<!--- Parámetros del TAG --->
<cfparam name="Attributes.name" default="txFecha" type="string"> <!--- Nombres del campo de la fecha --->
<cfparam name="Attributes.value" default="" type="string"> <!--- Nombres del campo de la fecha --->
<cfparam name="Attributes.class" default="" type="string"> <!--- Nombres del campo de la fecha --->
<cfparam name="Attributes.style" default="" type="string"> <!--- Nombres del campo de la fecha --->
<cfparam name="Attributes.label" default="" type="string"> <!--- Nombres del campo de la fecha --->


<table width="" border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr> 
		<td nowrap>
		  <cfif Attributes.label neq "">#Attributes.label#&nbsp;</cfif>
		  <input name="#Attributes.name#" id="#Attributes.name#" type="text" size="10" maxlength="10" 
                 <cfif Attributes.class neq "">class="#Attributes.class#"</cfif>
                 <cfif Attributes.style neq "">style="#Attributes.style#"</cfif>
                 value=<cfif Attributes.value neq "">"#LSDateFormat(Trim(Attributes.value),'DD/MM/YYYY')#"<cfelse>""</cfif>
                 onBlur="javascript: onblurdatetime(this);"
                 onKeyPress="javascript: return onkeypressdatetime(this,event);"
		  >
		  <a href="##" tabindex="-1"><img src="/imagenes/DATE_D.gif" alt="Calendario" name="Calendar#Attributes.name#" width="16" height="14" border="0" onClick="javascript: showCalendar('document.'+document.getElementById('#Attributes.name#').form.name+'.#Attributes.name#');"></a>
		</td>
	</tr>
	</cfoutput>
</table>
