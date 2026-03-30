<cfquery name="rsModXPaquete" datasource="#session.DSN#">
	select convert(varchar, pm.PAcodigo) as PAcodigo
		, pm.modulo
		, nombre
	from PaqueteModulo pm
		, Paquete p
		, Modulo m
	where	pm.PAcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PAcodigo#">
		and activo = 1
		and pm.PAcodigo=p.PAcodigo
		and pm.modulo=m.modulo
	order by orden	
</cfquery>

<form name="formModXPaquete" method="post" action="paquete_SQL.cfm" onSubmit="return valida(this);">
	<cfoutput>
		<input type="hidden" name="PAcodigo" id="PAcodigo" value="#form.PAcodigo#">					
		<input type="hidden" name="BajaD" id="BajaD" value="0">						
		<input type="hidden" name="modulo" id="modulo" value="">
		<table width="100%" border="0" cellspacing="2" cellpadding="2">	
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>	
		  </tr>
		  <cfif isdefined('rsModXPaquete') and rsModXPaquete.recordCount GT 0>
			<cfloop query="rsModXPaquete">
			  <tr>
				<td>
					<a href="##">
						<img border="0" alt="Eliminar este módulo" onClick="javascript: quitaMod('#rsModXPaquete.modulo#');" src="/cfmx/aspAdmin/imagenes/Borrar01_S.gif">
					</a>
				</td>
				<td nowrap>#rsModXPaquete.nombre#</td>	
			  </tr>
			</cfloop>  
		  </cfif>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>	
		  </tr>    
		  <tr>
			<td colspan="2" align="center"><input name="btnAgregaModulo" type="button" onClick="javascript: doConlisMod();" id="btnAgregaModulo" value="Agregar M&oacute;dulo"></td>
		  </tr>   
		</table> 
	</cfoutput>	
</form>

<script language="JavaScript" type="text/javascript">
//-------------------------------------------------------------------------------------------	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) 
				popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function doConlisMod(){
		<cfoutput>	
			<cfif isdefined('form.PAcodigo') and form.PAcodigo NEQ ''>
				var params ="";
				params = "?form=formModXPaquete"
						+ "&PAcodigo=#form.PAcodigo#";

				popUpWindow("modulo_conlis.cfm"+params,250,100,520,500);
			</cfif>
		</cfoutput>
	}
//-------------------------------------------------------------------------------------------			
	function quitaMod(cod){
		var f = document.formModXPaquete;
		
		if(confirm('Desea eliminar este modulo ?')){
			f.BajaD.value = 1;
			f.modulo.value = cod;			
			f.submit()
		}		
	}
//-------------------------------------------------------------------------------------------			
	function valida(f){
		alert('VALIDANDO -- ' + f.name);
		
		return false;
	}
</script>

<!--- 			<cfinclude template="paqueteModulos_form.cfm"> --->