<!--- Consultas --->
<cfquery name="rsCantidadLineas" datasource="#Session.DSN#">
	select count(*) as cantidad
	from DRNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>
<!--- Define los botones --->
<cfset botones = "">
<cfset aux = "">
<cfset camposExtra = "">
<cfif isDefined("permitirReintentar") and permitirReintentar eq true and rsCantidadLineas.cantidad gt 0>
	<cfset botones = botones & aux & "Reintentar">
	<cfset aux = ",">
</cfif>
<cfif isDefined("permitirModificar") and permitirModificar eq true and rsCantidadLineas.cantidad gt 0>
	<cfset CBcc = "'<input type=''text'' name=''CBcc'+convert(varchar,DRNlinea)+''' value='''+rtrim(CBcc)+''' maxlength=''25''>' CBcc">
	<cfset botones = botones & aux & "Modificar">
	<cfset aux = ",">
<cfelse>
	<cfset CBcc = "CBcc">
</cfif>
<cfif isDefined("permitirEliminar") and permitirEliminar eq true and rsCantidadLineas.cantidad gt 0>
	<cfset botones = botones & aux & "Eliminar">
	<cfset aux = ",">
	<cfset camposExtra = camposExtra & ",Pvalor100=" & Pvalor100>
	<cfset checkboxes = "S">
<cfelse>
	<cfset checkboxes = "N">
</cfif>
<cfif not isDefined("irA")>
	<cfset irA = "SQLXNomina.cfm">
</cfif>
<cfif not isDefined("MaxRows")>
	<cfset MaxRows = "20">
</cfif>

<!--- Define la lista --->
<cfinvoke 
component="rh.Componentes.pListas"
method="pListaRH"
returnvariable="pListaRet">
<cfinvokeargument name="columnas" value="ERNid,DRNlinea,NTIdescripcion, DRIdentificacion, #CBcc#, (DRNapellido1 + ' ' + DRNapellido2 + ' ' + DRNnombre) as Nombre, DRNtipopago, DRNperiodo, DRNliquido #camposExtra#"/>
<cfinvokeargument name="tabla" value="DRNomina a, NTipoIdentificacion b, Monedas c"/>
<cfinvokeargument name="filtro" value="a.NTIcodigo = b.NTIcodigo and a.Mcodigo = c.Mcodigo and ERNid = #Form.ERNid# order by DRNapellido1,DRNapellido2,DRNnombre,DRIdentificacion,DRNperiodo"/>
<cfinvokeargument name="desplegar" value="NTIdescripcion, DRIdentificacion,  CBcc, Nombre, DRNtipopago, DRNperiodo, DRNliquido"/>
<cfinvokeargument name="etiquetas" value="Tipo Identificación, Identificación,  Cuenta Cliente, Nombre, Tipo pago, Periodo, Importe"/>
<cfinvokeargument name="formatos" value="S,S,S,S,S,D,M"/>
<cfinvokeargument name="align" value="left,left,left,left,left,center,right"/>
<cfinvokeargument name="ajustar" value="N"/>
<cfinvokeargument name="checkboxes" value="#checkboxes#"/>
<cfinvokeargument name="formname" value="listaMNomina"/>
<cfinvokeargument name="irA" value="#irA#"/>
<cfinvokeargument name="showLink" value="false"/>
<cfinvokeargument name="navegacion" value="#navegacion#"/>
<cfinvokeargument name="showEmptyListMsg" value="true"/>
<cfinvokeargument name="botones" value="#botones#"/>
<cfinvokeargument name="keys" value="DRNlinea"/>
<cfinvokeargument name="MaxRows" value="#MaxRows#"/>
</cfinvoke>