<cfset LvarPlaca	 	= listGetAt(GvarXML_IE,1)>
<cfset LvarCedula		= listGetAt(GvarXML_IE,2)>
<cfset LvarcontrolAut		= listGetAt(GvarXML_IE,3)>

<!---			INTERFAZ DE CONSULTA DE ACTIVOS			--->
<cfset hilerarst = "">
<cfif isdefined("LvarCedula") and Len(LvarCedula) eq 0>
	<cfthrow message="La Cedula no existe o esta indefinida">
</cfif>

<cfquery datasource="#session.dsn#" name="rsCedula">
	Select DEid as Empleado
	from DatosEmpleado
	where Ecodigo = #session.Ecodigo#
	  and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCedula#">
</cfquery>

<cfif rsCedula.recordcount eq 0>
	<cfthrow message="Empleado no existe">
</cfif>

<cfset LvarDEid = rsCedula.DEid>

<cfquery datasource="#session.dsn#" name="rsStActivo">
	Select Aid, Astatus, Adescripcion, Aserie, AFCcodigo
	from Activos
	where Aplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPlaca#">
	  and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsStActivo.recordcount GT 1>
	<cfthrow message="Existe mas de un Activo para esa Placa.  Proceso Cancelado!">
</cfif>

<cfif rsStActivo.recordcount EQ 1 and rsStActivo.Astatus EQ 60>
	<cfthrow message="El Activo no puede ser procesado porque se encuentra retirado">
</cfif>

<cfset LvarExisteInfoPlaca = false>
<cfset LvarExistePlaca     = false>
<cfset LvarAid = -1>

<cfif rsStActivo.recordcount EQ 1>
	<cfset LvarExistePlaca     = true>
	<cfset LvarAid = rsStActivo.Aid>
</cfif>

<cfif LvarExistePlaca>
	<!--- CONSULTA LA PLACA EN ACTIVOS --->
	<cfquery datasource="#session.dsn#" name="rsPlaca">
		select 
				A.ACcodigodesc as AF2CAT, B.ACcodigodesc as AF3COD, 
				C.Adescripcion as AF4DES, F.CFcodigo as I04COD, 
				C.Aserie as AF4SER, C.AFCcodigo as TipoAct
		from Activos C
			inner join AClasificacion B
					inner join ACategoria A
					on A.Ecodigo    = B.Ecodigo
					and A.ACcodigo  = B.ACcodigo
			on  B.Ecodigo  = C.Ecodigo
			and B.ACcodigo = C.ACcodigo
			and B.ACid     = C.ACid

			inner join AFResponsables D
					inner join CFuncional F
					on F.CFid = D.CFid
					
			 on D.Aid     = C.Aid
			and D.Ecodigo = C.Ecodigo
			and D.AFRfini <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			and D.AFRffin >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			and D.DEid    =  #LvarDEid#
			
		where C.Aid = #LvarAid#
	</cfquery>
	<cfif rsPlaca.recordcount gt 0>
		<cfset LvarExisteInfoPlaca = true>
	</cfif>
</cfif>

<cfif LvarExisteInfoPlaca>
	<cfoutput query="rsPlaca">
		<cfset hilerarst = #Trim(AF2CAT)# & chr(182) & #Trim(AF3COD)# & chr(182) & #Trim(AF4DES)# & chr(182) & #Trim(I04COD)# & chr(182) & #Trim(AF4SER)# & chr(182) & #Trim(TipoAct)#>
	</cfoutput>
<cfelse>
	<!--- CONSULTA EN VALES --->
	<cfquery datasource="#session.dsn#" name="rsVPlaca">
		select 
				A.CRDRid,
				D.ACcodigodesc as AF2CAT, E.ACcodigodesc as AF3COD, 
				A.CRDRdescdetallada as AF4DES, C.CFcodigo as I04COD, 
				CRDRserie as AF4SER, A.AFCcodigo as TipoAct
		from CRDocumentoResponsabilidad A
			inner join CFuncional C
			on C.CFid = A.CFid
			
			inner join ACategoria D
			on D.ACcodigo  = A.ACcodigo
			and D.Ecodigo  = A.Ecodigo

			inner join AClasificacion E
			on 	E.ACid = A.ACid
			and E.ACcodigo = A.ACcodigo
			and E.Ecodigo  = A.Ecodigo

		where A.CRDRplaca	     	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarPlaca#">
		  and A.Ecodigo				= #session.Ecodigo#
		  and A.CRDRestado 			= 10
		  and A.DEid 				= #LvarDEid#
	</cfquery>

	<cfif rsVPlaca.recordcount gt 0>
		<cfset LvarCRDRid = rsVPlaca.CRDRid>
		<cfoutput query="rsVPlaca">
			<cfset hilerarst = #Trim(AF2CAT)# & chr(182) & #Trim(AF3COD)# & chr(182) & #Trim(AF4DES)# & chr(182) & #Trim(I04COD)# & chr(182) & #Trim(AF4SER)# & chr(182) & #Trim(TipoAct)#>
		</cfoutput>
		<cfif LvarcontrolAut eq "S">
			<!--- 		Marca el activo para que no se pueda recuperar, debido a que ya fue consultado por fondos 	--->
			<cfquery datasource="#session.dsn#">
				Update CRDocumentoResponsabilidad
				set CRDRutilaux = 1
				where CRDRid = #LvarCRDRid#
			</cfquery>
		</cfif>
	<cfelse>
		<cfthrow message="No existe datos de activo asociado a la informacin digitada">
	</cfif>
</cfif>
<cfset GvarXML_OE = '<response name="XML_OE">#hilerarst#</response>'>
