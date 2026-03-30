<!--- OPARRALES 2018-09-06 Estructura de ws_datoscliente ------>
<cfcomponent displayname="WEDatosCliente" output="false">
	<cfproperty name="Id" 				type="numeric">
	<cfproperty name="CodigoExterno" 	type="string">
	<cfproperty name="Nombre" 			type="string">
	<cfproperty name="Saldo" 			type="string">
	<cfproperty name="LimiteCredito"	type="string">
	<cfproperty name="Direccion" 		type="string">
	<cfproperty name="RFC"		 		type="string">

	<cffunction  name="init">
		<cfargument name="Id" 				type="numeric">
		<cfargument name="CodigoExterno" 	type="string">
		<cfargument name="Nombre" 			type="string">
		<cfargument name="Saldo" 			type="string" default="0">
		<cfargument name="LimiteCredito"	type="string" default="0">
		<cfargument name="Direccion" 		type="string" default="0">
		<cfargument name="RFC"		 		type="string">

		<cfset this.Id 				=arguments.Id >
		<cfset this.CodigoExterno 	=arguments.CodigoExterno >
		<cfset this.Nombre 			=arguments.Nombre >
		<cfset this.Saldo 			=arguments.Saldo >
		<cfset this.LimiteCredito	=arguments.LimiteCredito >
		<cfset this.Direccion 		=arguments.Direccion >
		<cfset this.RFC		 		=arguments.RFC >

		<cfreturn this>
	</cffunction>
</cfcomponent>