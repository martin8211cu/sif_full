<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>
<!--- PASO 0 --->
<!--- Carga informacion del contrato --->
<cfset Errores = "">
<cfset vsContinuar = true><!---Variable a utilizar al validar ----->
<cfoutput>
<cfquery name="RsContrato" datasource="#session.DSN#">
	select  a.SNcodigo , a.ECfechaini , a.ECfechafin , b.SNidentificacion 
	from EContratosCM a
		inner join SNegocios b
			on a.SNcodigo = b.SNcodigo
			and a.Ecodigo = b.Ecodigo
		where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and   a.ECid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
</cfquery>

<!----Verificar si esta encendido el parámetro de múltiples contratos---->
<cfquery name="rsParametro_MultipleContrato" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 730 
</cfquery>

<!--- PASO 1 --->
<!--- Carga el archivo desde el cliente al servidor --->
 <cffile   action = "upload" 
	fileField = "ARCHIVO" 
	destination = "#GetTempDirectory()#" 
	nameConflict = "overwrite">
<cfset uploadedFilename=#cffile.serverDirectory# & "/" & #cffile.serverFile#>
<!--- PASO 2 --->
<!--- carga el archivo importado y lo graba en una variable llamada Contenido --->
<cffile 	action = "read" 	
	file = "#uploadedFilename#"	
	variable = "Contenido">
<!--- PASO 3 --->
<!--- Recorre el archivo linea por linea para procesarlo --->
<cfset action = "COMMIT">   
<cftransaction action="begin">
	<!--- PASO 4 --->
	<!--- Separacion por filas --->
	<cfset Linea = 0>   
	<cfloop  list="#Contenido#"  delimiters="#chr(13)#" index="registro">
		<cfset registro = replace(#registro#,",,",",null,","All")>
		<cfif Len(Trim(registro)) GT 0 >
			<cfset Linea = Linea + 1>   
			<cfset Arreglo = listtoarray(registro,',')>
			<!----Validar que vengan todos los datos, tanto cuando esta o no encendido el parémetro----->
			<cfif rsParametro_MultipleContrato.RecordCount NEQ 0 and rsParametro_MultipleContrato.Pvalor EQ 1>
				<cfif ArrayLen(Arreglo) LT 13>
					<cf_errorCode	code = "50261"
									msg  = "En la línea <cfoutput>@errorDat_1@</cfoutput> hacen falta datos"
									errorDat_1="#Linea#"
					>	
				</cfif>
			<cfelse>
				<cfif ArrayLen(Arreglo) LT 10>
					<cf_errorCode	code = "50261"
									msg  = "En la línea <cfoutput>@errorDat_1@</cfoutput> hacen falta datos"
									errorDat_1="#Linea#"
					>				
				</cfif>
			</cfif>
			<!--- PASO 5 --->			
			<!---Validacion de datos --->
			<!---Validacion del tipo  --->
			<cfif trim(Arreglo[1]) neq 'A' and trim(Arreglo[1]) neq 'S'>
				<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el tipo<br>">
				<cfset action = "ROLLBACK">
			<cfelse>
				<!---Validacion del articulo o servicio  --->
				<cfif trim(Arreglo[1]) eq 'A'>
					<cfquery name="RsBien" datasource="#session.DSN#">
						select  Aid,Adescripcion  as descripcion
						from Articulos 
							where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  Acodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[2])#">
					</cfquery>
					<cfif RsBien.recordcount lte 0>
						<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código de artículo<br>">
						<cfset action = "ROLLBACK">
					</cfif>
				<cfelse>
					<cfquery name="RsBien" datasource="#session.DSN#">
						select  Cid,Cdescripcion  as descripcion
						from Conceptos 
							where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and  Ccodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[2])#">
					</cfquery>
					<cfif RsBien.recordcount lte 0>
						<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código de servicio<br>">
						<cfset action = "ROLLBACK">
					</cfif>
				</cfif> 
			</cfif>
			<!---Validacion del Moneda  --->
			<cfquery name="RsMoneda" datasource="#session.DSN#">
				select  Mcodigo 
				from Monedas
					where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  Miso4217   = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[3])#">
			</cfquery>
			<cfif RsMoneda.recordcount lte 0>
				<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código de la moneda<br>">			
				<cfset action = "ROLLBACK">
			</cfif>		
			<!---Validacion del Impuesto  --->
			<cfquery name="RsImpuesto" datasource="#session.DSN#">
				select  Icodigo 
				from Impuestos
					where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and  Icodigo     = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[4])#">
			</cfquery>
			<cfif RsImpuesto.recordcount lte 0>
				<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código del impuesto<br>">			
				<cfset action = "ROLLBACK">
			</cfif>	
			<!----Validación de la unidad de medida, Y Socio de negocio SOLO cuando está encendido el parámetro de múltiples contratos---->
			<cfif rsParametro_MultipleContrato.RecordCount NEQ 0 and rsParametro_MultipleContrato.Pvalor EQ 1>
				<cfquery name="RsUnidad" datasource="#session.DSN#">
					select Ucodigo from Unidades
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[11])#">
				</cfquery>
				<cfif RsUnidad.RecordCount EQ 0>
					<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código de la unidad<br>">			
					<cfset action = "ROLLBACK">					
				</cfif>				
				<cfquery name="RsSocio" datasource="#session.DSN#">
					select SNcodigo, SNidentificacion from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[13])#">
				</cfquery>
				<cfif RsSocio.RecordCount EQ 0 or (RsSocio.SNidentificacion NEQ RsContrato.SNidentificacion)>
					<cfset Errores = Errores & "La línea <cfoutput>#Linea#</cfoutput> tiene un valor incorrecto en el código del proveedor<br>">			
					<cfset action = "ROLLBACK">					
				</cfif>				
			</cfif>
			<!---Validacion de la existencia el un registro  --->	
			<cfif (trim(Arreglo[1]) eq 'A' or trim(Arreglo[1]) eq 'S') and RsBien.recordcount gt 0>
				<cfif rsParametro_MultipleContrato.RecordCount NEQ 0 and rsParametro_MultipleContrato.Pvalor EQ 1 and RsSocio.recordcount gt 0>
					<cfquery name="RsExiste" datasource="#session.DSN#">
						select ec.ECid
						from EContratosCM ec  
							inner join DContratosCM  dc
							  on ec.ECid = dc.ECid
							  and ec.Ecodigo = dc.Ecodigo
						where ec.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
							and dc.Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[11])#">
							and ec.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#RsSocio.SNcodigo#">
						  <cfif trim(Arreglo[1]) eq 'A'>
								and dc.Aid=<cfqueryparam value="#RsBien.Aid#" cfsqltype="cf_sql_numeric"> 
						  <cfelse>
								and dc.Cid=<cfqueryparam value="#RsBien.Cid#" cfsqltype="cf_sql_numeric">
						  </cfif>
						  and  (<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#RsContrato.ECfechaini#"> between ec.ECfechaini 
								  and ec.ECfechafin  
									or <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#RsContrato.ECfechafin#"> between ec.ECfechaini 
								  and ec.ECfechafin
								)
					</cfquery>
					<cfif RsExiste.recordcount gt 0>
						<cfset Errores = Errores & "La  línea <cfoutput>#Linea#</cfoutput>  ya existe en un contrato <br>">			
						<cfset action = "ROLLBACK">
					</cfif>						
				<cfelse>
					<cfquery name="rsExistencia" datasource="#session.DSN#">
						select 1
						from DContratosCM ec
							inner join EContratosCM b
								on ec.ECid = b.ECid
								and ec.Ecodigo = b.Ecodigo
						where ec.Ecodigo = <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
						  <cfif trim(Arreglo[1]) eq 'A'>
								and ec.Aid=<cfqueryparam value="#RsBien.Aid#" cfsqltype="cf_sql_numeric"> 
						  <cfelse>
								and ec.Cid=<cfqueryparam value="#RsBien.Cid#" cfsqltype="cf_sql_numeric">
						  </cfif>
						 and  (<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#"> between b.ECfechaini and b.ECfechafin)
								
					</cfquery>
					<cfif rsExistencia.RecordCount NEQ 0>
						<cf_errorCode	code = "50262"
										msg  = "La línea <cfoutput>@errorDat_1@</cfoutput> ya existe en un contrato"
										errorDat_1="#Linea#"
						>
					</cfif>
				</cfif>	<!----Fin de parámetro----->
			</cfif><!---Fin de existencia registro----->
			<!---insertar el registro  --->	
			<cfif action eq "COMMIT">
				<cfquery name="RsInsert" datasource="#session.DSN#">
					insert into DContratosCM (
						ECid,
						Ecodigo,
						DCtipoitem,
						Aid,
						Cid ,
						Mcodigo,
						Icodigo, 
						DCpreciou,
						DCtc ,
						DCgarantia,
						DCdescripcion,
						DCdescalterna, 
						BMUsucodigo,
                        DCdiasEntrega
						<cfif rsParametro_MultipleContrato.RecordCount NEQ 0 and rsParametro_MultipleContrato.Pvalor EQ 1>							
							,Ucodigo
							,DCcantcontrato
							,DCcantsurtida
						</cfif>
					)				
					values(
						<cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
						 <cfqueryparam value="#trim(Arreglo[1])#" cfsqltype="cf_sql_char">, 
						 <cfif trim(Arreglo[1]) eq 'A'>
							<cfqueryparam value="#RsBien.Aid#" cfsqltype="cf_sql_numeric">,
							null,
						 <cfelse>
							null,
							<cfqueryparam value="#RsBien.Cid#" cfsqltype="cf_sql_numeric">,
						 </cfif>
						 <cfqueryparam value="#RsMoneda.Mcodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#RsImpuesto.Icodigo#" cfsqltype="cf_sql_char">,
						 #LvarOBJ_PrecioU.enCF(trim(Arreglo[5]))#,
						 <cfqueryparam value="#trim(Arreglo[6])#"   cfsqltype="cf_sql_float">,
						 <cfqueryparam value="#trim(Arreglo[7])#"   cfsqltype="cf_sql_integer">,
						 <cfif trim(Arreglo[8]) eq '-' or  len(trim(Arreglo[8])) EQ 0>
							<cfqueryparam value="#RsBien.descripcion#"   cfsqltype="cf_sql_varchar">,
						 <cfelse>
							 <cfqueryparam value="#trim(Arreglo[8])#"   cfsqltype="cf_sql_varchar">,
						 </cfif>
						 <cfif trim(Arreglo[9]) eq '-' or  len(trim(Arreglo[9])) EQ 0>
							<cfqueryparam value="#RsBien.descripcion#"   cfsqltype="cf_sql_varchar">,
						 <cfelse>
							 <cfqueryparam value="#trim(Arreglo[9])#"   cfsqltype="cf_sql_varchar">,
						 </cfif>
						 <cfqueryparam value="#session.Usucodigo#"  cfsqltype="cf_sql_integer">,
                         <cfqueryparam value="#trim(Arreglo[10])#" cfsqltype="cf_sql_integer">
						 <cfif rsParametro_MultipleContrato.RecordCount NEQ 0 and rsParametro_MultipleContrato.Pvalor EQ 1>
							,<cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arreglo[11])#">
							,<cfqueryparam cfsqltype="cf_sql_float" value="#trim(Arreglo[12])#" null="#trim(Arreglo[12]) eq '-'#">
							,0.00
						 </cfif>
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
	<cftransaction action = "#action#"/>   
</cftransaction>
<form  name="form1"  method="post">
	<input  type="hidden" name="ECid"  value="#form.ECid#">
	<cfif action neq "COMMIT">
		<input  type="hidden" name="ERROR"  value="#Errores#">
	</cfif>	
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">
	<cfif action eq "COMMIT">
		document.form1.action = 'contratos.cfm';
	<cfelse>
		document.form1.action = 'importarDC.cfm';	
	</cfif>
	document.forms[0].submit();
</script>
</body>
</html>
</cfoutput>	




