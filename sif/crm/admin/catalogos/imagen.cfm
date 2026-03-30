<cfset error = false >
 	<cftry>
		<!--- Copia la imagen a un folder del servidor --->
		<cffile action="Upload" fileField="form.CRMEimagen"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
		
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