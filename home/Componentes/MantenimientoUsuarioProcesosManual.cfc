<cfcomponent>

<cffunction name="actualizar">

<cfargument name="Usucodigo" type="numeric" required="yes" default="0">
<cfargument name="Ecodigo"   type="numeric" required="yes" default="0">
<cfargument name="CEcodigo"  type="numeric" required="yes" default="0">
<cfargument name="SScodigo"  type="string"  required="yes" default="">
<cfargument name="SMcodigo"  type="string"  required="yes" default="">
<cfargument name="SPcodigo"  type="string"  required="yes" default="">

	<cfset where = ArrayNew(1)>
	<cfif Arguments.Usucodigo neq 0>
	  <cfset ArrayAppend(where, "Usucodigo = " & Arguments.Usucodigo)>
	</cfif>
	<cfif Arguments.Ecodigo neq 0>
	  <cfset ArrayAppend(where, "Ecodigo = " & Arguments.Ecodigo)>
	</cfif>
	<cfif Arguments.CEcodigo neq 0>
	  <cfset ArrayAppend(where, "(select count(1) from Empresa where CEcodigo = " & Arguments.CEcodigo & " and Ecodigo = Ecodigo) > 0")>
	</cfif>
	<cfif Len(Arguments.SScodigo) neq 0>
	  <cfset ArrayAppend(where, "SScodigo = '" & Replace(Arguments.SScodigo, "'","''") & "'")>
	</cfif>
	<cfif Len(Arguments.SMcodigo) neq 0>
	  <cfset ArrayAppend(where, "SMcodigo = '" & Replace(Arguments.SMcodigo, "'","''") & "'")>
	</cfif>
	<cfif Len(Arguments.SPcodigo) neq 0>
	  <cfset ArrayAppend(where, "SPcodigo = '" & Replace(Arguments.SPcodigo, "'","''") & "'")>
	</cfif>
	<cfif ArrayLen(where) EQ 0>
		<cfset ArrayAppend(where, "1=1")>
	</cfif>
	<cfset where = "where " & ArrayToList(where, " and ")>

<cfsetting requesttimeout="1000">
<cflock name="vUsuarioProcesos" timeout="10" throwontimeout="yes">
	<!--- 
		vUsuarioProcesos = vUsuarioProcesosCalc 
		
		Logica vieja:
			vUsuarioProcesosTemp1 = vUsuarioProcesos 		con where						'temp1: los existentes que cumplen con el filtro
			vUsuarioProcesosTemp2 = vUsuarioProcesosCalc 	con where						'temp2: los correctos (vista) que cumplen con el filtro
			vUsuarioProcesosTemp1 -= vUsuarioProcesosTemp2									'temp1: borra los correctos (quedan solo existentes incorrectos)
			vUsuarioProcesosTemp2 -= vUsuarioProcesos										'temp2: borra los existentes (quedan solo nuevos correctos)

			vUsuarioProcesos -= vUsuarioProcesosTemp1										'Borra los existentes incorrectos
			vUsuarioProcesos += vUsuarioProcesosTemp2										'Agrega nuevos correctos
			
		simplificado:
			vUsuarioProcesosTemp2 = vUsuarioProcesosCalc 	con where						'Guarda en tabla fisica correctos (vista) que cumplen con filtro
			
			vUsuarioProcesos -= vUsuarioProcesos 		con where - vUsuarioProcesosTemp2	'De los ya existentes que cumplan con el filtro, borra los incorrectos
			vUsuarioProcesos += vUsuarioProcesosTemp2  - vUsuarioProcesos					'Agregar los nuevos a los ya existentes
	--->

	<cfquery datasource="asp">
		delete from vUsuarioProcesosTemp1
	</cfquery>
	<cfquery datasource="asp">
		delete from vUsuarioProcesosTemp2
	</cfquery>
	<!--- Salvo la vista en tabla fisica con los correctos que cumplan con el filtro --->
	<cfquery datasource="asp">
		insert INTO vUsuarioProcesosTemp2 (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
		select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
		  from vUsuarioProcesosCalc v
			   #PreserveSingleQuotes(where)#
	</cfquery>

	<cftransaction>
		<!--- Elimino los incorrectos que cumplen con el filtro --->
		<cfquery datasource="asp">
			delete from vUsuarioProcesos
			       #PreserveSingleQuotes(where)#
			   and (
					select count(1)
					  from vUsuarioProcesosTemp2
					 where Usucodigo = vUsuarioProcesos.Usucodigo
					   and Ecodigo	 = vUsuarioProcesos.Ecodigo
					   and SScodigo	 = vUsuarioProcesos.SScodigo
					   and SMcodigo	 = vUsuarioProcesos.SMcodigo
					   and SPcodigo  = vUsuarioProcesos.SPcodigo
					) = 0
		</cfquery>

		<!--- Agrego los correctos nuevos --->
		<cfquery datasource="asp">
			insert into vUsuarioProcesos (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
			select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
			  from vUsuarioProcesosTemp2 v
			 where (
					select count(1)
					  from vUsuarioProcesos
					 where Usucodigo = v.Usucodigo
					   and Ecodigo   = v.Ecodigo
					   and SScodigo  = v.SScodigo
					   and SMcodigo  = v.SMcodigo
					   and SPcodigo  = v.SPcodigo
					) = 0
		</cfquery>
	</cftransaction>
	<cfquery datasource="asp">
		delete from vUsuarioProcesosTemp2
	</cfquery>
</cflock>

</cffunction>

</cfcomponent>