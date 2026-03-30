<cfparam name="modo" default="ALTA">
<cfset errorFoto = false >
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cffunction name="convFoto" access="private" returntype="any">
	<cfargument name="Pfoto" type="numeric" required="true" default="<!--- foto --->">
	
		<!--- Copia la imagen a un folder del servidor --->
		<cfif Pfoto EQ 1 and isdefined('form.PfotoG')>
			<cffile action="Upload" filefield="form.PfotoG"  destination="#gettempdirectory()#" nameconflict="Overwrite" accept="image/*"> 
		<cfelseif Pfoto EQ 2 and isdefined('form.PfotoP')>
			<cffile action="Upload" filefield="form.PfotoP"  destination="#gettempdirectory()#" nameconflict="Overwrite" accept="image/*"> 
		</cfif>
		
		<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
		<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
		<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
		<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
		<!--- Formato para sybase --->
		<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
		<cfif not isArray(tmp)>
			<cfset ts_Pfoto = "">
		</cfif>
		<cfset miarreglo=ListtoArray(ArraytoList(tmp,","),",")>
		<cfset miarreglo2=ArrayNew(1)>
		<cfset temp=ArraySet(miarreglo2,1,8,"")>
	
		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
		</cfloop>
	
		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 10>
				<cfset miarreglo2[i] = "0" & toString(Hex[(miarreglo[i] MOD 16)+1])>
			<cfelse>
				<cfset miarreglo2[i] = trim(toString(Hex[(miarreglo[i] \ 16)+1])) & trim(toString(Hex[(miarreglo[i] MOD 16)+1]))>
			</cfif>
		</cfloop>
		<cfset temp = ArrayPrepend(miarreglo2,"0x")>
		<cfset ts_Pfoto = ArraytoList(miarreglo2,"")>
		
		<cfreturn tmp>
</cffunction>

<cfif ( isdefined("form.Alta") or isdefined("form.Cambio") ) >
	<cfif isdefined('form.PfotoG') and Len(Trim(form.PfotoG)) gt 0>
		<cfset ts_fotoG = convFoto(1)>
	</cfif>	
	<cfif isdefined('form.PfotoP') and Len(Trim(form.PfotoP)) gt 0>
		<cfset ts_fotoP = convFoto(2)>		
	</cfif>	
</cfif>

<cfif not isdefined("form.Nuevo")>
		<cfset LvarSecuenciar = false>
		<cfif isdefined("form.ALTA")>						
			<cfset LvarSecuenciar = true>
			<cfif isdefined('form.SMNtipo') and form.SMNtipo EQ 'M'>
				<cfquery name="rscodMenu" datasource="asp">
					Select (coalesce(max(SMNcodigo),0) + 1) as codMenu
					from SMenues
				</cfquery>
				
				<cfquery name="rsSMenues" datasource="asp">
					insert into	SMenues 
							(SMNcodigo,SScodigo, SMcodigo, SMNcodigoPadre, SMNtipo, SMNtipoMenu,
							SMNtitulo, SMNexplicativo, SMNorden, SMNcolumna,
							SMNimagenGrande, SMNimagenPequena,SMNenConstruccion,
							opcionprin, siempreabierto)
					values 	(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscodMenu.codMenu#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcodigoPadre#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMNtipo#">
							, <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.SMNtipoMenu#">
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMNtitulo#">
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMNexplicativo#">
							, 9999
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcolumna#">
							<cfif errorFoto EQ false and isdefined('ts_fotoG')>
								, <cfqueryparam cfsqltype="cf_sql_blob" value="#ts_fotoG#">
							<cfelse>
								, null
							</cfif>
							<cfif errorFoto EQ false and isdefined('ts_fotoP')>
								, <cfqueryparam cfsqltype="cf_sql_blob" value="#ts_fotoP#">
							<cfelse>
								, null
							</cfif>
							<cfif isdefined('form.SMNenConstruccion')>
								, 1
							<cfelse>
								, 0
							</cfif>							
							<cfif isdefined('form.opcionprin')>
								, 1
							<cfelse>
								, 0
							</cfif>							
							<cfif isdefined('form.siempreabierto')>
								, 1
							<cfelse>
								, 0
							</cfif>
					)
				</cfquery>
			<cfelse>
				<cfquery name="rscodMenu" datasource="asp">
					Select (coalesce(max(SMNcodigo),0) + 1) as codMenu
					from SMenues
				</cfquery>
				
				<cfquery name="rsSMenues" datasource="asp">
					insert into	SMenues 
							(SMNcodigo,SScodigo, SMcodigo, SMNcodigoPadre, SMNtipo, SPcodigo,
							SMNorden,SMNcolumna,SMNenConstruccion,
							opcionprin, siempreabierto)
					values 	(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscodMenu.codMenu#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcodigoPadre#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMNtipo#">
							, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SPcodigo#">
							, 9999
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcolumna#">
							<cfif isdefined('form.SMNenConstruccion')>
								, 1
							<cfelse>
								, 0
							</cfif>
							<cfif isdefined('form.opcionprin')>
								, 1
							<cfelse>
								, 0
							</cfif>							
							<cfif isdefined('form.siempreabierto')>
								, 1
							<cfelse>
								, 0
							</cfif>
					)
				</cfquery>
			</cfif>
		<cfelseif isdefined("form.CAMBIO") >
			<cfset LvarSecuenciar = true>
			<cfif Form.SMNcodigoPadre NEQ "" AND isdefined('form.SMNorden') and form.SMNorden NEQ ''>
				<!--- Deja lugar libre para cambiar el orden de la opcion --->
				<cfquery name="rsSMenues" datasource="asp">
					update SMenues
					   set SMNorden = SMNorden + 1
					 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
					   and SMNcodigoPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcodigoPadre#">
					   and SMNorden >= <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.SMNorden#">
			   </cfquery>
			</cfif>
			<cfquery name="rsSMenues" datasource="asp">
				update SMenues 
				set	SScodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					, SMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
					, SMNcolumna=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SMNcolumna#">
					<cfif isdefined('form.SMNorden') and form.SMNorden NEQ ''>
						, SMNorden=<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.SMNorden#">
					<cfelse>
						, SMNorden=9999
					</cfif>							
					<cfif isdefined('form.SMNtipo') and form.SMNtipo EQ 'M'>
						, SMNtipoMenu=<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.SMNtipoMenu#">
						, SMNtitulo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMNtitulo#">
						, SMNexplicativo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SMNexplicativo#">
						<cfif errorFoto EQ false and isdefined('ts_fotoG')>
							, SMNimagenGrande=<cfqueryparam cfsqltype="cf_sql_blob" value="#ts_fotoG#">
						<cfelseif isdefined('form.ckBorrarImgG')>
							, SMNimagenGrande=null							
						</cfif>
						<cfif errorFoto EQ false and isdefined('ts_fotoP')>					
							, SMNimagenPequena=<cfqueryparam cfsqltype="cf_sql_blob" value="#ts_fotoP#">
						<cfelseif isdefined('form.ckBorrarImgP')>
							, SMNimagenPequena=null								
						</cfif>													
					<cfelse>
						, SPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SPcodigo#">
					</cfif>
					
					<cfif isdefined('form.SMNenConstruccion')>
						, SMNenConstruccion=1
					<cfelse>
						, SMNenConstruccion=0
					</cfif>
					<cfif isdefined('form.opcionprin')>
						, opcionprin=1
					<cfelse>
						, opcionprin=0
					</cfif>
					<cfif isdefined('form.siempreabierto')>
						, siempreabierto=1
					<cfelse>
						, siempreabierto=0
					</cfif>
				where SMNcodigo=<cfqueryparam value="#form.SMNcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfset modo = "CAMBIO">
		<cfelseif isdefined("form.BAJA")>
			<cfquery name="rsSMenues" datasource="asp">
				delete from SMenues 
				where SMNcodigo=<cfqueryparam value="#form.SMNcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
		</cfif>

		<cfif LvarSecuenciar>
			<!--- Resecuencia el Orden por cada Nivel (mismo padre) --->
			<!---  
				and right('0000'||<cf_dbfunction datasource="asp" name="to_char" args="o.SMNorden">,4)||<cf_dbfunction datasource="asp" name="to_char" args="o.SMNcodigo"> <=
				right('0000'||<cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNorden">,4)||<cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNcodigo">
			--->
			
			<cfquery name="rsSMenues" datasource="asp">
				update SMenues
				   set SMNorden = (
						select count(1) from SMenues o
						 where o.SScodigo = SMenues.SScodigo
						 and o.SMcodigo = SMenues.SMcodigo
						 and o.SMNcodigoPadre = SMenues.SMNcodigoPadre
						 and  right('0000'#_Cat#<cf_dbfunction datasource="asp" name="to_char" args="o.SMNorden">      ,4)#_Cat#<cf_dbfunction datasource="asp" name="to_char" args="o.SMNcodigo"> <=
							  right('0000'#_Cat#<cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNorden">,4)#_Cat#<cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNcodigo">
					 )
				 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
			</cfquery>
			
			<!--- Inicializa todos los paths y niveles --->
			<cfquery name="rsSMenues" datasource="asp">
				update SMenues
				   set SMNpath = null
					  ,SMNnivel = null
				 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
			</cfquery>
			
			<!--- Inicializa el path y nivel del Menu Inicial --->
			<cfquery name="rsSMenues" datasource="asp">
				update SMenues
				   set SMNpath  = '000'
					  ,SMNnivel = 0
				 where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
				   and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
				   and SMNcodigoPadre is null
			</cfquery>
			<!--- Actualiza el path y el nivel de cada opcion de menu con la información de su padre --->
			<cfloop condition="1 eq 1">
				<!---SMNpath || '|' || right('000'||<cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNorden">,3)--->
				<cfquery name="rsSMenues" datasource="asp">
						update SMenues
							set SMNpath  = (
						 								select SMNpath #_Cat# '|'#_Cat# right('000'#_Cat# <cf_dbfunction datasource="asp" name="to_char" args="SMenues.SMNorden">,3)
														from SMenues p
														where SMenues.SScodigo = p.SScodigo
															and SMenues.SMcodigo = p.SMcodigo
															and SMenues.SMNcodigoPadre = p.SMNcodigo
															and p.SMNnivel is not null
						 								) 
														,SMNnivel = (
						 								select SMNnivel + 1
														from SMenues p
														where SMenues.SScodigo = p.SScodigo
															and SMenues.SMcodigo = p.SMcodigo
															and SMenues.SMNcodigoPadre = p.SMNcodigo
															and p.SMNnivel is not null
						 								) 
							where SScodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SScodigo#">
							and SMcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
							and SMNnivel is null
				</cfquery>
				<cfquery name="rsSMenues" datasource="asp">
					select 1
					  from SMenues m, SMenues p
					 where m.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
					   and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SMcodigo#">
					   and m.SScodigo = p.SScodigo
					   and m.SMcodigo = p.SMcodigo
					   and m.SMNcodigoPadre = p.SMNcodigo
					   and m.SMNnivel is null
					   and p.SMNnivel is not null
				</cfquery>
				<cfif (rsSMenues.Recordcount EQ 0)><cfbreak></cfif>
			</cfloop>
		</cfif>
</cfif>

<cfoutput>
<form action="menues.cfm" method="post">
	<input type="hidden" name="modo" value="#modo#">
	<input type="hidden" name="nivel" value="3">
	<input type="hidden" name="SScodigo" value="#Form.SScodigo#">
	<input type="hidden" name="SMcodigo" value="#Form.SMcodigo#">
	<cfif modo neq "ALTA">
		<input type="hidden" name="SMNcodigo" id="SMNcodigo" value="#Form.SMNcodigo#">	
	<cfelse>
		<input type="hidden" name="SMNtipo" value="<cfif isdefined("form.SMNtipo") and len(trim(form.SMNtipo)) neq 0>#Form.SMNtipo#</cfif>">		
		<input type="hidden" name="SMNcodigoPadre" value="#Form.SMNcodigoPadre#">
	</cfif>	
	<input name="Pagina" type="hidden" value="<cfif isdefined("form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>

