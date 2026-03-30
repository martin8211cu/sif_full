
<!--- Mostrar Estado de la Línea de Detalle --->
<cfset estado = "">
<cfset estadodesplegar = "">
<cfset estadoetiquetas = "">
<cfset estadoformatos = "">
<cfset estadoalign = "">
<cfif (isDefined("showestado")) and (len(trim(showestado))) and (showestado)>
	<cfset estado = estado & ",
		case HDRNestado 
			when 1 then '<img src=/cfmx/rh/imagenes/iedit.gif>'
			when 2 then '<img src=/cfmx/rh/imagenes/idelete.gif>'
			else '<img src=/cfmx/rh/imagenes/question.gif>'
		end as estadoimg">
	<cfset estadodesplegar = ",estadoimg">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/> 
	
	<cfset estadoetiquetas = ",#LB_Estado#">
	<cfset estadoformatos = ",S">
	<cfset estadoalign = ",center">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoIdentificacion"
Default="Tipo Identificación"
returnvariable="LB_TipoIdentificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Identificacion"
Default="Identificación"
returnvariable="LB_Identificacion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CuentaCliente"
Default="Cuenta Cliente"
returnvariable="LB_CuentaCliente"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre"
Default="Nombre"
returnvariable="LB_Nombre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_TipoPago"
Default="Tipo pago"
returnvariable="LB_TipoPago"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Periodo"
Default="Periodo"
returnvariable="LB_Periodo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Importe"
Default="Importe"
returnvariable="LB_Importe"/>



<!--- Lista de Detalles de Nómina. Ver Argumentos Variables para entender que debe definirse. --->
<cfinvoke 
	component="rh.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet">

	<!--- Argumentos Fijos --->
	<cfinvokeargument name="columnas" value="ERNid,DRNlinea,NTIdescripcion, HDRIdentificacion,  CBcc, {fn concat({fn concat({fn concat({fn concat(HDRNapellido1 , ' ' )}, HDRNapellido2 )}, ' ' )}, HDRNnombre )} as Nombre, HDRNtipopago, HDRNperiodo, HDRNliquido #estado#"/>
	<cfinvokeargument name="tabla" value="HDRNomina a, NTipoIdentificacion b, Monedas c"/>
	<cfinvokeargument name="filtro" value="a.NTIcodigo = b.NTIcodigo and a.Mcodigo = c.Mcodigo and ERNid = #Form.ERNid# #filtro# order by HDRNapellido1,HDRNapellido2,HDRNnombre, HDRIdentificacion,HDRNperiodo"/>
	<cfinvokeargument name="desplegar" value="NTIdescripcion, HDRIdentificacion,  CBcc, Nombre, HDRNtipopago, HDRNperiodo, HDRNliquido #estadodesplegar#"/>
	<cfinvokeargument name="etiquetas" value="#LB_TipoIdentificacion#,#LB_Identificacion#,#LB_CuentaCliente#,#LB_Nombre#,#LB_TipoPago#,#LB_Periodo#,#LB_Importe# #estadoetiquetas#"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,D,M #estadoformatos#"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,center,right #estadoalign#"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="keys" value="ERNid,DRNlinea"/>

	<!--- (*) Argumentos Variables 2 --->
	<cfif isDefined("irA") and len(trim(irA)) NEQ 0>
		<cfinvokeargument name="irA" value="#irA#"/>
	<cfelse>
		<cfinvokeargument name="showLink" value="false"/>
	</cfif>
	<cfif isDefined("showLink") and len(trim(showLink)) NEQ 0>
		<cfinvokeargument name="showLink" value="#showLink#"/>
	</cfif>
	<cfif isDefined("checkboxes") and len(trim(checkboxes)) NEQ 0>
		<cfinvokeargument name="checkboxes" value="#checkboxes#"/>
	</cfif>
	<cfif isDefined("botones") and len(trim(botones)) NEQ 0>
		<cfinvokeargument name="botones" value="#botones#"/>
	</cfif>
	<cfif isDefined("maxrows") and len(trim(maxrows)) NEQ 0>
		<cfinvokeargument name="maxrows" value="#maxrows#"/>
	</cfif>
</cfinvoke>