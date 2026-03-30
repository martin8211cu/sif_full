<cfquery name="rsRequisitos" datasource="#session.DSN#">
	Select convert(varchar,mr.Mcodigo) as Mcodigo
		, m2.Mcodificacion
		, convert(varchar,mr.McodigoRequisito) as McodigoRequisito
		, m2.Mnombre		
	from MateriaRequisito mr
		, Materia m
		, Materia m2
	where m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and m.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and mr.Mcodigo=m.Mcodigo
		and mr.McodigoRequisito=m2.Mcodigo
	order by m2.Mcodificacion
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<form name="formReqMatRegulares" method="post" action="materiaRequisitos_SQL.cfm">
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
		</cfif>
		 <!--- ********************************* --->
	 
		<input type="hidden" name="Mcodigo" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
		<input type="hidden" name="McodigoRequisito" id="McodigoRequisito" value="">	
		<input type="hidden" name="btnAgregarReq" id="btnAgregarReq" value="0">
		<input type="hidden" name="Mtipo" id="Mtipo" value="#form.T#">
	</cfoutput>		

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr><td align="center" height="5"></td></tr>
				
			  <tr>
				<td align="center">
					<strong>C&oacute;digo de materia:</strong>
					<input name="Mcodificacion" type="text" id="Mcodificacion">
					<input type="hidden" name="Mnombre" id="Mnombre" value="">
					<input 	name="btnAgregaRequisitos" type="button" id="btnAgregaRequisitos" value="Agregar Requisito" onClick="javascript: doConlisMateriaReq();"
							title="Agregar una materia que es requisito para la materia actual"></td>
			  </tr>
			</table>
		</td>
	  </tr>	
	  <tr>
		<td colspan="3"><hr></td>
	  </tr>
	  <tr bgcolor="#CCCCCC">
		<td>&nbsp;</td>
      	<td><strong>C&oacute;digo</strong></td>
      	<td><strong>Requisito</strong></td>
	  </tr>
	  <cfif isdefined('rsRequisitos') and rsRequisitos.recordCount GT 0>
	  	<cfoutput query="rsRequisitos">
			  <tr>
				<td align="center">
					<a href="##">
						<img border="0" alt="Eliminar este Requisito" onClick="javascript: quitaReq(#McodigoRequisito#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
					</a>
				</td>
				<td>#Mcodificacion#</td>
				<td>#Mnombre#</td>
			  </tr>
	    </cfoutput>
		
		<input type="hidden" name="btnBorrarReq" id="btnBorrarReq" value="0">					
		<input type="hidden" name="IdReqBorrar" id="IdReqBorrar" value="">		
	  </cfif>
  </table>
</form>
<iframe name="frame_QRYmateria" id="frame_QRYmateria" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function quitaReq(cod){
		var f = document.formReqMatRegulares;
		
		if(confirm('Desea eliminar este Requisito ?')){
			f.btnBorrarReq.value = 1;
			f.btnAgregarReq.value = 0;
			f.IdReqBorrar.value = cod;			

			f.submit()
		}
	}	
	
//---------------------------------------------------------------------------------------		
	function abreConlisMat(){	
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsRequisitos.McodigoRequisito,',')#</cfoutput>"		
		
		if(codsQuitar == '')
			codsQuitar = "<cfoutput>#form.Mcodigo#</cfoutput>"		
		else
			codsQuitar += ",<cfoutput>#form.Mcodigo#</cfoutput>"			
			
		<cfif isdefined('rsForm') and rsForm.EScodigo NEQ ''>
			params = "?form=formReqMatRegulares&EScodigo_filtro=<cfoutput>#rsForm.EScodigo#</cfoutput>&tipo=M&quitar=" + codsQuitar + "&cod=McodigoRequisito&btn=btnAgregarReq&conexion=<cfoutput>#session.DSN#</cfoutput>";			
		<cfelse>
			params = "?form=formReqMatRegulares&tipo=M&quitar=" + codsQuitar + "&cod=McodigoRequisito&btn=btnAgregarReq&conexion=<cfoutput>#session.DSN#</cfoutput>";			
		</cfif>	

		popUpWindow("ConlisMateriasRequisitos.cfm"+params,250,200,650,400);		
	}	
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisMateriaReq() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsRequisitos.McodigoRequisito,',')#</cfoutput>"		
		
		if(codsQuitar == '')
			codsQuitar = "<cfoutput>#form.Mcodigo#</cfoutput>"		
		else
			codsQuitar += ",<cfoutput>#form.Mcodigo#</cfoutput>"		
			
		if(document.formReqMatRegulares.Mcodificacion.value != ''){
			document.formReqMatRegulares.btnAgregarReq.value = 1;
			params = "&cod=McodigoRequisito&name=Mcodificacion&desc=Mnombre&conexion=<cfoutput>#session.DSN#</cfoutput>&quitar=" + codsQuitar;			
			var fr = document.getElementById("frame_QRYmateria");
			
			fr.src = "QueryMaterias.cfm?dato="+document.formReqMatRegulares.Mcodificacion.value+"&form=formReqMatRegulares"+params;
		}else{
			<cfif isdefined('rsForm') and rsForm.EScodigo NEQ ''>
				params = "?form=formReqMatRegulares&EScodigo_filtro=<cfoutput>#rsForm.EScodigo#</cfoutput>&tipo=M&quitar=" + codsQuitar + "&cod=McodigoRequisito&btn=btnAgregarReq&conexion=<cfoutput>#session.DSN#</cfoutput>";			
			<cfelse>
				params = "?form=formReqMatRegulares&tipo=M&quitar=" + codsQuitar + "&cod=McodigoRequisito&btn=btnAgregarReq&conexion=<cfoutput>#session.DSN#</cfoutput>";			
			</cfif>

			popUpWindow("ConlisMateriasRequisitos.cfm"+params,250,200,650,400);
		}
	}	
//---------------------------------------------------------------------------------------	
</script>