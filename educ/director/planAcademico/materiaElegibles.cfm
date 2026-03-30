<cfquery name="rsMatElegibles" datasource="#session.DSN#">
	Select convert(varchar,McodigoElegible) as McodigoElegible
		, m2.Mnombre
		, m2.Mcodificacion
	from MateriaElegible me
		, Materia m
		, Materia m2
	where m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
		and me.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">	
		and me.Mcodigo=m.Mcodigo		
		and me.McodigoElegible=m2.Mcodigo
	order by Mnombre
</cfquery>

<cfquery name="rsCantElegibles" datasource="#session.DSN#">
	Select count(McodigoElegible) as cant
	from MateriaElegible me
		, Materia m
	where m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and me.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and me.Mcodigo=m.Mcodigo
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<form name="formMatElegibles" method="post" action="materiaElegibles_SQL.cfm">
	<cfoutput>
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
		</cfif>
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
			<input name="Nivel" type="hidden" value="2">  
		</cfif>
		 <!--- ********************************* --->
	
		<input type="hidden" name="Mcodigo" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
		<input type="hidden" name="McodigoElegible" id="McodigoElegible" value="">	
		<input type="hidden" name="btnAgregarEleg" id="btnAgregarEleg" value="0">
		<input type="hidden" name="Mtipo" id="Mtipo" value="#form.T#">	
	 </cfoutput>
	 
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr><td align="center" height="5"></td></tr>
				
			  <tr>
				<td align="center">
					<strong>C&oacute;digo de Materia Elegible:</strong>
					<input name="Mcodificacion" type="text" id="Mcodificacion">
					<input type="hidden" name="Mnombre" id="Mnombre" value="">
					<input 	name="btnAgregarElegibles" type="button" id="btnAgregarElegibles" value="Agregar Requisito" onClick="javascript: doConlisElegibles();"
							title="Agregar una materia elegible que es requisito para la materia actual">
				</td>
			  </tr>
			</table>			
		</td>
	  </tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>
	  <tr bgcolor="#CCCCCC">
		<td>&nbsp;</td>
		<td><strong>C&oacute;digo</strong></td>
	    
      <td><strong>Elegible</strong></td>
	  </tr>
	  <cfif isdefined('rsMatElegibles') and rsMatElegibles.recordCount GT 0>
	  	<cfoutput query="rsMatElegibles">
			  <tr>
				<td align="center">
					<a href="##">
						<img border="0" alt="Eliminar este Requisito" onClick="javascript: quitaEleg(#McodigoElegible#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
					</a>
				</td>
				<td>#Mcodificacion#</td>
				<td>#Mnombre#</td>
			  </tr>
	    </cfoutput>
		
		<input type="hidden" name="btnBorrarEleg" id="btnBorrarEleg" value="0">					
		<input type="hidden" name="IdElegBorrar" id="IdElegBorrar" value="">		
	  </cfif>
  </table>
</form>

<iframe name="frame_QRYmateria" id="frame_QRYmateria" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowElegibles(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function quitaEleg(cod){
		var f = document.formMatElegibles;
		
		if(confirm('Desea eliminar este Requisito ?')){
			f.btnBorrarEleg.value = 1;
			f.IdElegBorrar.value = cod;	

			f.submit()
		}
	}	
//---------------------------------------------------------------------------------------	
	function abreConlisMat(){	
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsMatElegibles.McodigoElegible,',')#</cfoutput>"
		
		if(codsQuitar == '')
			codsQuitar = "<cfoutput>#form.Mcodigo#</cfoutput>"		
		else
			codsQuitar += ",<cfoutput>#form.Mcodigo#</cfoutput>"			
			
		<cfif isdefined('rsForm') and rsForm.EScodigo NEQ ''>
			params = "?form=formMatElegibles&EScodigo_filtro=<cfoutput>#rsForm.EScodigo#</cfoutput>&tipo=M&quitar=" + codsQuitar + "&cod=McodigoElegible&btn=btnAgregarEleg&conexion=<cfoutput>#session.DSN#</cfoutput>";			
		<cfelse>
			params = "?form=formMatElegibles&tipo=M&quitar=" + codsQuitar + "&cod=McodigoElegible&btn=btnAgregarEleg&conexion=<cfoutput>#session.DSN#</cfoutput>";			
		</cfif>	

		popUpWindow("ConlisMateriasRequisitos.cfm"+params,250,200,650,400);		
	}	
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisElegibles() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsMatElegibles.McodigoElegible,',')#</cfoutput>"
		if(codsQuitar == '')
			codsQuitar = "<cfoutput>#form.Mcodigo#</cfoutput>"		
		else
			codsQuitar += ",<cfoutput>#form.Mcodigo#</cfoutput>"

		if(document.formMatElegibles.Mcodificacion.value != ''){
			document.formMatElegibles.btnAgregarEleg.value = 1;
			params = "&cod=McodigoElegible&name=Mcodificacion&desc=Mnombre&conexion=<cfoutput>#session.DSN#</cfoutput>&quitar=" + codsQuitar;			
			var fr = document.getElementById("frame_QRYmateria");
			
			fr.src = "QueryMaterias.cfm?dato="+document.formMatElegibles.Mcodificacion.value+"&form=formMatElegibles"+params;
		}else{
			<cfif isdefined('rsForm') and rsForm.EScodigo NEQ ''>
				params = "?form=formMatElegibles&EScodigo_filtro=<cfoutput>#rsForm.EScodigo#</cfoutput>&tipo=M&quitar=" + codsQuitar + "&cod=McodigoElegible&btn=btnAgregarEleg&conexion=<cfoutput>#session.DSN#</cfoutput>";			
			<cfelse>
				params = "?form=formMatElegibles&tipo=M&quitar=" + codsQuitar + "&cod=McodigoElegible&btn=btnAgregarEleg&conexion=<cfoutput>#session.DSN#</cfoutput>";			
			</cfif>

			popUpWindowElegibles("ConlisMateriasRequisitos.cfm"+params,250,200,650,400);			
		}
	}	
//---------------------------------------------------------------------------------------	
</script>