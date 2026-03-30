<cfset modo = 'ALTA'>


<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select a.CFid, a.CMCid, b.CFcodigo, b.CFdescripcion, c.Usucodigo, c.DEid, c.CMCnombre
		from CMCompradoresCF a
		inner join CFuncional b
		on a.CFid=b.CFid
		 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 inner join CMCompradores c
		 on a.CMCid=c.CMCid
		 and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		where a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisCompradores() {
		var params = "";
			params = "?formulario=form1&CMCid=CMCid&desc=CMCnombre";
		popUpWindow("/cfmx/sif/cm/catalogos/ConlisCompradores.cfm"+params,250,200,650,400);
	}
</script>

<cfoutput>
<form style="margin:0;" name="form1" action="CompradoresCFunc-sql.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td align="right" nowrap><strong>Centro Funcional:</strong>&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					#trim(data.CFcodigo)# - #data.CFdescripcion#
					<input type="hidden" name="CFid" value="#data.CFid#" >
				<cfelse>
					<cf_rhcfuncional>
				</cfif>

			</td>
		</tr>

		<tr>
			<td align="right" nowrap><strong>Comprador:</strong>&nbsp;</td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="CMCnombre" id="CMCnombre" tabindex="1" readonly value="<cfif modo neq 'ALTA'>#data.CMCnombre#</cfif>" size="57" maxlength="80">
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
				<cfelse>
					#data.CMCnombre#
				</cfif>
				<input type="hidden" name="CMCid" value="<cfif modo neq 'ALTA'>#data.CMCid#</cfif>" >
			</td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		
		<tr>
			<td align="center" colspan="2">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript:if( confirm('Desea eliminar el registro?') ){return true;} return false;">
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript:location.href='CompradoresCFunc.cfm'">
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar">
				</cfif>
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>
		
	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CFid.required = true;
	objForm.CFid.description="Centro Funcional";

	objForm.CMCid.required = true;
	objForm.CMCid.description="Comprador";

	function deshabilitarValidacion(){
		objForm.CFid.required = false;
		objForm.CMCid.required = false;
	}

</script>
