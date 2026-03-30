<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif modo neq "ALTA" and isdefined('form.EDPid')>
<cfquery name="rsPersona" datasource="#Session.DSN#">
	select a.DEid, {fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ')}, a.DEapellido2)}, ', ')}, a.DEnombre) } as nombreEmpl, 	a.DEidentificacion, b.EDvid 
	from EquipoDivPersona b
	inner join EDPersonas a on  
	b.DEid = a.DEid
	where EDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPid#">  
</cfquery>

</cfif>

<script>            
	        var popUpWin=0;
            function popUpWindow(URLStr, left, top, width, height){
              if(popUpWin) {
                       if(!popUpWin.closed) popUpWin.close();
              }
              popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
            }
            function doConlisCA() {
                       popUpWindow("../catalogo/AgregarP.cfm?popup=c" ,250,200,950,850);
            }

</script>
<cfoutput>
<input type="text" name="DEcarbitro" id="DEcarbitro" tabindex="1" value="<cfif modo eq 'CAMBIO' and isdefined('form.EDPid')>#rsPersona.nombreEmpl#</cfif>" maxlength="80" size="40" readonly='true'	onFocus="javascript:this.select();"> 
<input type="hidden" name="EDcarbitro" id="EDcarbitro" value="<cfif modo eq 'CAMBIO' and isdefined('form.EDPid')>#rsPersona.DEid#<cfelseif modo eq 'CAMBIO'>#form.EDcarbitro#</cfif>">

				
				<img src="/cfmx/rh/imagenes/Description.gif" border="0" align="absmiddle" hspace="2" onclick="javascript:doConlisCA();">
</cfoutput>