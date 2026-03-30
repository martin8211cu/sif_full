
<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0 >
	<cfset  form.modo = url.modo >
</cfif>
<!---********************************* --->
<!---** para entrar en modo cambio  ** --->
<!---********************************* --->
<cfif isdefined("Form.Cambio")>
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
<!---********************************* --->
<cfif modo neq "ALTA">
<!---************* CAmbio ********** --->
<!---********************************************************* --->
<!---**aqui se definen las diferentes consultas SQL         ** --->
<!---********************************************************* --->
	<cfquery datasource="#session.Fondos.dsn#"  name="TraeSql" >	
		select CJM00COD,CJP02IMP,CJP02ORD,timestamp
		from  CJP002
		where CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CJM00COD#" >
	</cfquery>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#TraeSql.timestamp#" returnvariable="ts">
	</cfinvoke>
	
	<cfquery datasource="#session.Fondos.dsn#"  name="rsFondo" >	
		select CJM00COD,CJM00DES
		from  CJM000
		where CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CJM00COD#" >
	</cfquery>	
	
	<cfquery datasource="#session.Fondos.dsn#"  name="rsImpuesto" >	
		SELECT I92COD CJP02IMP,I92DES CJP02IMPDES FROM I92ARC
		where I92COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.CJP02IMP#">
	</cfquery>		
	
	<cfquery datasource="#session.Fondos.dsn#"  name="rsOrdenS" >	
		SELECT CJM16COD CJP02ORD,CJM16DES CJP02ORDDES FROM CJM016 WHERE CJM16CIE <> 1
		and CJM16COD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TraeSql.CJP02ORD#">
	</cfquery>		

</cfif>
 <!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->

<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>

<table width="100%" border="0" >
	<tr>
		<td width="12%"  align="left" >
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
			<form action="../catalogos/cjc_SqlParamGlobal.cfm" method="post" name="form1" 
			onSubmit="javascript:finalizar();">
			<cfoutput>
					<table width="100%" border="0">
					  <!---********************************************************* --->
					  <tr>
					  <td width="40%" ><strong>Fondo:</strong></td>
						<cfif modo eq 'ALTA' >
							<td width="60%" colspan="4">	
								<cf_cjcConlis 	
										size		="30"  
										name 		="CJM00COD" 
										desc 		="CJM00DES" 
										cjcConlisT 	="cjc_traefondo"
								>
							</td>	
							<cfelse>
							<td colspan="4">	
									<INPUT 	TYPE="textbox" 
											NAME="CJM00COD" 
											ID  ="CJM00COD"
											VALUE="<cfif modo neq "ALTA">#rsFondo.CJM00COD#</cfif>" 
											SIZE="4" 
											MAXLENGTH="4" 
											ONBLUR=""
											ONFOCUS="this.select(); " 
											ONKEYUP="" 
											DISABLED
											style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>
									<INPUT 	TYPE="textbox" 
											NAME="CJM00DES" 
											ID  ="CJM00DES"
											VALUE="<cfif modo neq "ALTA">#rsFondo.CJM00DES#</cfif>" 
											SIZE="40" 
											MAXLENGTH="40" 
											ONBLUR=""
											ONFOCUS="this.select(); " 
											ONKEYUP="" 
											DISABLED
											style="border: medium none; text-align:left; size:auto; font-weight:bold; visibility:"
									>
								</td>							
							</cfif>	
						
					  </tr>	
					  <!---********************************************************* --->
					  <tr>
					  <td ><strong>Impuesto:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >
								<cf_cjcConlis 	
										size		="30"  
										name 		="CJP02IMP" 
										desc 		="CJP02IMPDES" 
										cjcConlisT 	="cjc_traeImp"
										query       ="#rsImpuesto#"
								>
							<cfelse>
								<cf_cjcConlis 	
									size		="30"  
									name 		="CJP02IMP" 
									desc 		="CJP02IMPDES" 
									cjcConlisT 	="cjc_traeImp"
								>
							</cfif>	
						</td>
					  </tr>
					  <!---********************************************************* --->
					  <tr>
					  <td ><strong>Ord. de servicio:</strong></td>
						<td colspan="4">	
							<cfif modo neq 'ALTA' >
								<cf_cjcConlis 	
										size		="30"  
										name 		="CJP02ORD" 
										desc 		="CJP02ORDDES" 
										cjcConlisT 	="cjc_traeOrdenS"
										query       ="#rsOrdenS#" 
								>
							<cfelse>
								<cf_cjcConlis 	
									size		="30"  
									name 		="CJP02ORD" 
									desc 		="CJP02ORDDES" 
									cjcConlisT 	="cjc_traeOrdenS"
								>
							</cfif>	
						</td>
					  </tr>	
					  <!---********************************************************* --->	
					  <tr>
						<td colspan="4">
						<cfinclude  template="../portlets/GenBotones.cfm">
						</td>
					  </tr>
					  <!---********************************************************* --->
					
				</cfoutput>
				</table>
  			  <input 	name="timestamp" type="hidden" id="timestamp" value="<cfif modo NEQ "ALTA" ><cfoutput>#ts#</cfoutput></cfif>">		
		    </form>
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>

		<td width="12%"  align="left" valign="top">
				<cfinvoke 
					 component="sif.fondos.Componentes.pListas"
					method="pLista"
					returnvariable="pListaRet">
					<cfinvokeargument name="conexion" value="#session.Fondos.dsn#"/>
					<cfinvokeargument name="tabla" value="CJP002"/>
					<cfinvokeargument name="columnas" value="CJM00COD,CJP02IMP,CJP02ORD"/>
					<cfinvokeargument name="desplegar" value="CJM00COD,CJP02IMP,CJP02ORD"/>
					<cfinvokeargument name="etiquetas" value="Fondo,Impuesto,Orden de servicio"/>
					<cfinvokeargument name="formatos" value="S,S,S"/>
					<cfinvokeargument name="filtro" value=""/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="MaxRows" value="10"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="keys" value="CJM00COD"/>
					<cfinvokeargument name="irA" value="cjc_ParamGlobal.cfm"/>
				</cfinvoke>	
		</td>
  	</tr>
</table>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objform1 = new qForm("form1");

	objform1.CJM00COD.required = true;
	objform1.CJM00COD.description="Fondo de trabajo";	 



	function novalidar(){
		objform1.CJM00COD.required 	= false;
	}


	function finalizar(){
	document.form1.CJM00COD.disabled = false;

	}
</script> 
