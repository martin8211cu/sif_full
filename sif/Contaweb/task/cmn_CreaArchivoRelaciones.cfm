<!--- Creacion del Archivo con el reporte para cada una de las transacciones generadas
con la depreciasion --->

<!---********************* Funciones ***********************--->
<cffunction name="fnGraba">
	<cfargument name="contenido" required="yes">
	<cfargument name="fin" required="no" default="no">
	<cfset contenido = replace(contenido,"   "," ","All")>
	<cfset contenidohtml = contenidohtml & contenido>
	<cfif len(contenidohtml) GT 1048576>
			<cffile action="append" file="#tempfile_TXT#" output="#contenidohtml#">
			<cfset contenidohtml = "">
	</cfif>
	<cfif fin>
			<cffile action="append" file="#tempfile_TXT#" output="#contenidohtml#">
			<cfset contenidohtml = "">
	</cfif>
</cffunction> 

<cfset nomproceso = "Generacion de Reportes de Relaciones">
<cfsetting requesttimeout="3600">
<cfsetting enablecfoutputonly="yes">

<!--- Obtiene las transacciones que tienen que ver con la depreciasion para generar el reporte --->
<cfquery datasource="#session.Conta.dsn#" name="relaciones">
	Select AF8NUM,AF8DES
	from ICE_SIF..AFM008
	where AF8TIP = 'DA'
</cfquery>

<cfoutput query="relaciones">

	<cftry>
		<cfset numero_relacion = AF8NUM>
		<cfset descripcion_relacion = AF8DES>
		
		<cfquery datasource="#session.Conta.dsn#" name="sql_relacionesgen">
		declare @error int
		
		exec @error = ICE_SIF..sp_AF0004_WEB
						@AF8NUM = <cfqueryparam  cfsqltype="cf_sql_integer"  value="#numero_relacion#">
		
		if @error != 0 begin
			raiserror 40000 'Error Generando el Reporte'
			return
		end	
		</cfquery>
		
		
		<cfif sql_relacionesgen.recordcount gt 0>
			
		
			<cfset contenidoBloque = "">
			
			<!--- Generacion del Encabezado --->
			<cfset contenidoBloque = contenidoBloque & "LISTADO DE TRANSACCIONES DE ACTIVOS FIJOS" & chr(13)>
			<cfset contenidoBloque = contenidoBloque & "Fecha: " & #Mid(Now(),6,19)# & chr(13)>
			<cfset contenidoBloque = contenidoBloque & #trim(USER)# & chr(13)>
			<cfset contenidoBloque = contenidoBloque & "" & chr(13)>
			
		
			<!--- Empieza la generacion del Archivo --->
			
			<cfset contenidoBloque =  contenidoBloque & 'UEN  ACTIVO       DESCRIPCION                    TRANS.  MONTO          CENTRO FUNC.  % Aplic. CUENTA DE DEBITO                         CUENTA DE CREDITO' & chr(13)>
			<cfset contenidoBloque =  contenidoBloque & '---- ------------ ------------------------------ ------- -------------- ------------- -------- ---------------------------------------- --------------------------------------------------------' & chr(13)>
		
			<!--- <cfset contenidoBloque = contenidoBloque & "" & chr(13)> --->
			<cfset contenidoBloque = contenidoBloque & "RELACION: " & #numero_relacion# & chr(9)>
			<cfset contenidoBloque = contenidoBloque & #descripcion_relacion# & chr(13)>
						
			<!--- Se crea el archivo --->
			<cfset N_ARCH = "rpt_" & #trim(USER)# & "_" & #trim(numero_relacion)#>
			<cfset tempfile_TXT = "#GetTempDirectory()##N_ARCH#">
			<cffile action="write" file="#tempfile_TXT#" output="#contenidoBloque#" nameconflict="overwrite">
			<cfset contenidohtml = "">
			<cfset contenidoBloque = "">		
	
			 
	
			<!--- Se empieza a incluir la informacion --->
			<cfset Categ_act="">
			<cfset Clase_act="">
			<cfset sumatoria=0>
			<cfset sumatoriaglobal=0>
			<cfset sumatoriaglobalrel=0>
			<cfset cambiopag=0>
			<cfloop query="sql_relacionesgen">
			
				<cfset cambiopag=cambiopag + 1>
				
				<cfif Categ_act neq sql_relacionesgen.AF2CAT or Clase_act neq sql_relacionesgen.AF3COD>
					
					<cfif Clase_act neq "" and Clase_act neq sql_relacionesgen.AF3COD>
						<cfset contenidoBloque =  contenidoBloque & "Total por Clase......................:                       " & LSCurrencyFormat(sumatoria,"none") & chr(13)>
					</cfif>					
					<cfif Categ_act neq "" and Categ_act neq sql_relacionesgen.AF2CAT>
						<cfset contenidoBloque =  contenidoBloque & "Total por Categoria..................:                       " & LSCurrencyFormat(sumatoriaglobal,"none") & chr(13)>													
						<cfset sumatoriaglobalrel=sumatoriaglobalrel + sumatoriaglobal>
					</cfif>
					
					<cfset contenidoBloque =  chr(13) & contenidoBloque & "CATEGORIA: " & sql_relacionesgen.AF2CAT & chr(9)>					
					<cfset contenidoBloque =  contenidoBloque & sql_relacionesgen.AF2NOM & chr(9)>
					<cfset contenidoBloque =  contenidoBloque & "CLASE: " & sql_relacionesgen.AF3COD & chr(9)>
					<cfset contenidoBloque =  contenidoBloque & sql_relacionesgen.AF3NOM & chr(13)>					
												
					<cfset sumatoriaglobal=sumatoriaglobal + sumatoria>
					<cfset sumatoria=0>
				</cfif>		
									
				<cfif cambiopag eq 75>
					<cfset contenidoBloque = "" & chr(13) & chr(13)>
					<cfset contenidoBloque = contenidoBloque & "LISTADO DE TRANSACCIONES DE ACTIVOS FIJOS" & chr(13)>
					<cfset contenidoBloque = contenidoBloque & "Fecha: " & #Mid(Now(),6,19)# & chr(13)>
					<cfset contenidoBloque = contenidoBloque & #trim(USER)# & chr(13)>
					<cfset contenidoBloque = contenidoBloque & "" & chr(13)>				
					<cfset contenidoBloque =  contenidoBloque & 'UEN  ACTIVO       DESCRIPCION                    TRANS.  MONTO          CENTRO FUNC.  % Aplic. CUENTA DE DEBITO                         CUENTA DE CREDITO' & chr(13)>
					<cfset contenidoBloque =  contenidoBloque & '---- ------------ ------------------------------ ------- -------------- ------------- -------- ---------------------------------------- --------------------------------------------------------' & chr(13)>							
				
					<cfset cambiopag=0>
					
				</cfif>
				
				
				<cfset largo=4-len(trim(sql_relacionesgen.CODUEN))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.CODUEN) & espacios & " ">
				<cfset largo=12-len(trim(sql_relacionesgen.AF4PLA))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.AF4PLA) & espacios & " ">
				<cfset largo=29-len(trim(sql_relacionesgen.AF4DES))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.AF4DES) & espacios & trim(sql_relacionesgen.AF4CTR) & " ">
				<cfset largo=7-len(trim(sql_relacionesgen.AF09NT))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.AF09NT) & espacios & " ">
				<cfset largo=14-len(trim(sql_relacionesgen.AF9MFI))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(LSCurrencyFormat(sql_relacionesgen.AF9MFI,"none")) & espacios & " ">
				<cfset largo=13-len(trim(sql_relacionesgen.I04COD))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.I04COD) & espacios & " ">
				<cfset largo=8-len(trim(sql_relacionesgen.Porcentaje))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.Porcentaje) & espacios & " ">
				<cfset largo=40-len(trim(sql_relacionesgen.Cuenta_Debito))><cfset espacios=RepeatString("-", largo)>
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.Cuenta_Debito) & espacios & " ">				
				<cfset contenidoBloque =  contenidoBloque & trim(sql_relacionesgen.Cuenta_Credito) & chr(13)>        
				
				<cfset fnGraba(contenidoBloque,false)>
				<cfset contenidoBloque = "">

				<cfset Categ_act=sql_relacionesgen.AF2CAT>
				<cfset Clase_act=sql_relacionesgen.AF3COD>
				<cfset sumatoria=sumatoria + sql_relacionesgen.AF9MFI>
				<!--- <cfset placa_act=sql_relacionesgen.AF4PLA>	 --->
				
			</cfloop>		

			<cfif sumatoria gt 0>
				<cfset sumatoriaglobal=sumatoriaglobal + sumatoria>
				<cfset sumatoriaglobalrel=sumatoriaglobalrel + sumatoriaglobal>
				<cfset contenidoBloque =  contenidoBloque & "Total por Clase......................:                       " & LSCurrencyFormat(sumatoria,"none") & chr(13)>									
				<cfset contenidoBloque =  contenidoBloque & "Total por Categoria..................:                       " & LSCurrencyFormat(sumatoriaglobal,"none") & chr(13)>													
				<cfset contenidoBloque =  contenidoBloque & "Total  por Relación..................:                       " & LSCurrencyFormat(sumatoriaglobalrel,"none") & chr(13)>
								
				<cfset sumatoria=0>				
				<cfset fnGraba(contenidoBloque,false)>
				<cfset contenidoBloque = "">			
			</cfif>
			
			<cfset fnGraba(contenidoBloque,true)> 
			<!--- 
			Archivo Generado
			<cfoutput>#Mid(Now(),6,19)#</cfoutput> --->

  		    <cfquery datasource="#session.Conta.dsn#" name="verifica">
			Select AF8NUM
			from tbl_reportesdepAF
			where AF8NUM = #numero_relacion#
			</cfquery>

			<cfif verifica.recordcount eq 0>

				<!--- Incluye los datos en una tabla de reportes para que el usuario los pueda bajar --->			
				<cfquery datasource="#session.Conta.dsn#">
				INSERT tbl_reportesdepAF(AF8NUM,
										 AF8DES,
										 NARCH,
										 ESTADO,
										 FECHAGEN,
										 AFUSER)
				values(                  #numero_relacion#,
										'#descripcion_relacion#',
										'#N_ARCH#',
										 0,
										'#Mid(Now(),6,19)#',
										'#Session.Usuario#')
				</cfquery>
			
			</cfif>
			
		</cfif>
		
		<cfcatch type="any">
	
			<!--- Incluye el error en una tabla de errores --->
			<cfquery datasource="#session.Conta.dsn#">
			Insert into tbl_AFerrorescf(id,Proceso,Mensaje,Detalle)
			values(#LLAVE#,'#nomproceso#','#Mid(trim(cfcatch.Detail),41,len(trim(cfcatch.Detail)))#','#numero_relacion#')
			</cfquery>
												
		</cfcatch>
	
	</cftry> 
	
</cfoutput>