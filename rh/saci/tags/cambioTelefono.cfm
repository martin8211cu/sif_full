<cfparam 	name="Attributes.cuentaid"		type="string"	default="">						<!--- Id de Cuenta (es Obligatorio) --->
<cfparam 	name="Attributes.contratoid"	type="string"	default="">						<!--- Id de Producto (es Obligatorio)--->
<cfparam 	name="Attributes.loginid"		type="string"	default="">						<!--- Id de Login(es Obligatorio)--->
<cfparam 	name="Attributes.cliente"		type="string"	default="">						<!--- Id del cliente (es Obligatorio)--->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.porFilas"	type="string"	default="false">				<!--- por si se desea presentar los compos en forma vertical --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->

<cfoutput>
	<cfquery name="rsTelefonos" datasource="#Attributes.Conexion#">
		select distinct a.CTid, a.Contratoid, b.LGnumero, 
			case b.LGtelefono
			when null then 'Sin asignar'
			else b.LGtelefono end as LGtelefono   
		from ISBproducto a
			inner join  ISBlogin b
				on b.Contratoid = b.Contratoid
				and b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.loginid#">
				and b.Habilitado=1	
			inner join  ISBserviciosLogin c
				on c.LGnumero = c.LGnumero
				and  c.PQcodigo=a.PQcodigo
				and c.TScodigo='ACCS'
				and c.Habilitado=1
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.cuentaid#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.contratoid#">
	</cfquery>
	
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<input name="LGnumero#Attributes.sufijo#" type="hidden" value="#Attributes.loginid#" />
		<input name="Contratoid#Attributes.sufijo#" type="hidden" value="#Attributes.contratoid#" />
		<input name="CTid#Attributes.sufijo#" type="hidden" value="#Attributes.cuentaid#" />
		<input name="cliente#Attributes.sufijo#" type="hidden" value="#Attributes.cliente#" />
		<tr>
			<td align="right"><label><cf_traducir key="actual">Actual&nbsp;</cf_traducir><label></td>
			<td><cfif len(trim(rsTelefonos.LGtelefono))>
					#rsTelefonos.LGtelefono#
				<cfelse>
					&lt;Sin Asignar&gt;
				</cfif>
				<input name="LGtelefono#Attributes.sufijo#" type="hidden" value="#rsTelefonos.LGtelefono#" />
			</td>
		<cfif Attributes.porFilas></tr><tr></cfif>
			<td align="right"><label><cf_traducir key="nuevo">Nuevo&nbsp;</cf_traducir><label></td>
			<td><cf_campoNumerico name="nuevoLGtelefono#Attributes.sufijo#" decimales="-1" size="12" maxlength="15" value="" tabindex="1"></td>
		</tr>
	</table>
	
</cfoutput>
