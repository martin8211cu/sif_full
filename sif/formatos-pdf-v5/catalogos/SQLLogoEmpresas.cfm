
<cfif isdefined("Form.btnEliminar") 
	and isdefined("Form.Empresa") and Len(Trim(Form.Empresa)) GT 0>
	<cfquery name="rsdelete" datasource="emperador">
		set nocount on
		delete LogoEmpresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Empresa#">		  
		set nocount off
	</cfquery>
</cfif>

<cfset error = false >
<cfif not isdefined("Form.btnEliminar")>
	<cfif Len(Trim(Form.FiletoUpload)) GT 0 >
			<cftry>
				<!--- Copia la imagen a un folder del servidor servidor --->
				<cffile action="Upload" fileField="Form.FiletoUpload"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
				
				<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
				
				<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
				<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
				
				<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
		
				<!--- Formato para sybase --->
				<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
			
				<cfif not isArray(tmp)>
					<cfset ts = "">
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
				<cfset ts = ArraytoList(miarreglo2,"")>
		
			<cfcatch type="any">
				<cfset error = true >
			</cfcatch> 
			</cftry>
	<cfelse>
		<cfset ts = "">
	</cfif>	

	<cfif not error >
		
		<cfquery name="ABCimagen" datasource="emperador">
			set nocount on
		<cfif isDefined("btnAgregar")>
							
			insert LogoEmpresas 
			(Ecodigo, Llogo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Empresa#">,
				#ts#
			)
						
		<cfelseif isDefined("btnCambiar")>
		
			update LogoEmpresas
			set <cfif len(trim(ts)) GT 0>Llogo = #ts#</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Empresa#">
		
		<cfelse>
			select 1
		</cfif>

			set nocount off
		</cfquery>
</cfif>

</cfif>		


<form action="LogoEmpresas.cfm" method="post" name="sql">
	<cfif not isDefined("Form.btnNuevo")>	
	<input name="Empresa" type="hidden" value="<cfif isdefined("Form.Empresa")><cfoutput>#Form.Empresa#</cfoutput></cfif>"> 		
	</cfif>
	<input name="modo" type="hidden" 
		value="<cfif not isDefined ("Form.btnNuevo") and not isDefined ("Form.btnEliminar") and isdefined("Form.Empresa") and (Len(Trim(Form.Empresa)) GT 0) >CAMBIO</cfif>">

</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


