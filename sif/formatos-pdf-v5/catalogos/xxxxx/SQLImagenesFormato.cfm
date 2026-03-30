<cfif isdefined("Form.btnEliminar") 
	and isdefined("Form.FMT01COD") and Len(Trim(Form.FMT01COD)) GT 0
	and isdefined("Form.FMT03LIN") and Len(Trim(Form.FMT03LIN)) GT 0>
	<cfquery name="rsdelete" datasource="emperador">
		set nocount on
		delete FMT003
		where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
		  and FMT03LIN = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.FMT03LIN#">
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
			declare @cont int
			select @cont = isnull(max(FMT03LIN),0)+1 from FMT003 
			where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
			
			insert FMT003 
			(FMT01COD, FMT03LIN, FMT03IMG, FMT03FIL, FMT03COL, FMT03ALT, FMT03ANC, FMT03BOR, FMT03CFN, FMT03CBR, FMT03EMP)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">, 
				@cont, 
				#ts#, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03FIL#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03COL#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ALT#">, 
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ANC#">,
				<cfif isDefined("Form.FMT03BOR")>1,<cfelse>0,</cfif> 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CFN#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CBR#">,
				<cfif isDefined("Form.FMT03EMP")>1<cfelse>0</cfif>
			)			
		<cfelseif isDefined("btnCambiar")>
			update FMT003
			set <cfif len(trim(ts))>FMT03IMG = #ts#,</cfif>
				FMT03FIL = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03FIL#">, 
				FMT03COL = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03COL#">, 
				FMT03ALT = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ALT#">, 
				FMT03ANC = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.FMT03ANC#">, 
				FMT03BOR = <cfif isDefined("Form.FMT03BOR")>1,<cfelse>0,</cfif>
				FMT03CFN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CFN#">, 
				FMT03CBR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FMT03CBR#">,
				FMT03EMP = <cfif isDefined("Form.FMT03EMP")>1<cfelse>0</cfif>
			where FMT01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
			  and FMT03LIN = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#Form.FMT03LIN#">
		<cfelse>
			select 1
		</cfif>

			set nocount off
		</cfquery>
</cfif>

</cfif>		


<!---<form action="ImagenesFormato.cfm?FMT01COD=<cfoutput>#Form.FMT01COD#</cfoutput>" method="post" name="sql">--->
<form action="ImagenesFormato.cfm" method="post" name="sql">
 	<input name="FMT01COD" type="hidden" value="<cfif isdefined("form.FMT01COD")><cfoutput>#form.FMT01COD#</cfoutput></cfif>">	 	
	<cfif not isDefined("Form.btnNuevo")>	
	<input name="FMT03LIN" type="hidden" value="<cfif isdefined("form.FMT03LIN")><cfoutput>#form.FMT03LIN#</cfoutput></cfif>"> 		
	</cfif>
	<input name="modo" type="hidden" 
		value="<cfif not isDefined ("Form.btnNuevo") and not isDefined ("Form.btnEliminar") and isdefined("Form.FMT01COD") and (Len(Trim(Form.FMT01COD)) GT 0) 
					and isdefined("Form.FMT03LIN") and (Len(Trim(form.FMT03LIN)) GT 0)>CAMBIO</cfif>">

</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


