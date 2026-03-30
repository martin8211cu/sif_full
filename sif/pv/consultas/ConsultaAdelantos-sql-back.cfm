<!--- Creado por: 	  Rebeca Corrales Alfaro  --->
<!--- Fecha: 		  30/05/2005 8:00 a.m. --->
<!--- Modificado por: --->
<!--- Fecha: 		  --->



<cfquery name="rsReporte" datasource="#session.DSN#">
 select 
	 A.FAX01NTR as Transaccion,
	 A.FAX01STA as Estado,
	 H.Oficodigo as Oficina, 
	 H.Odescripcion as Ofic_descrip,
	 rtrim(D.FAM01CODD) as CodigoCaja, 
	 C.FAX11DOC as Documento,
	 A.FAX01FEC as FechaFactura,
	 ltrim(rtrim(E.CDCidentificacion)) || ' - ' || ltrim(rtrim(E.CDCnombre)) as Cliente,
	 coalesce(B.FAX14MON,1) as Aplicado,
	 coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
	 coalesce(A.FAX01TOT,0.0) as TotalLinea,
	 case when A.FAX01TPG = 1 then 'Crédito'
	   else 'Contado'
	 end as TipoPago,
	 G.Miso4217 as CodigoMoneda
from FAX001 as A
	left outer join FAX014 as B /* Adelantos*/
	  on A.FAX01NTR = B.FAX01NTR
	 and A.FAM01COD = B.FAM01COD
	 and A.Ecodigo = B.Ecodigo

	left outer join FAX011 as C      /* No. de Documento */
	  on A.FAM01COD = C.FAM01COD
	 and A.FAX01NTR = C.FAX01NTR
	 and A.Ecodigo = C.Ecodigo
	 and C.FAX11LIN = (select max(FAX11LIN) 
					   from FAX011 doc 
					   where doc.FAM01COD = C.FAM01COD 
					     and doc.FAX01NTR = C.FAX01NTR 
					     and doc.Ecodigo = C.Ecodigo )
 
	inner join FAM001 as D     /*cajas*/
	  on A.FAM01COD = D.FAM01COD
	 and A.Ecodigo = D.Ecodigo
	 <cfif isdefined("form.FAM01CODD") and len(trim(form.FAM01CODD))>
		and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM01CODD#">
	</cfif>	 
  
	inner join ClientesDetallistasCorp as E /* clientes*/
	  on A.CDCcodigo = E.CDCcodigo
  
	inner join Monedas as G /*monedas */
	  on A.Mcodigo = G.Mcodigo
	 and A.Ecodigo = G.Ecodigo
  
	inner join Oficinas as H /*Oficinas */
	  on A.Ocodigo = H.Ocodigo
	 and A.Ecodigo = H.Ecodigo

where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   and A.FAX01STA IN ('T', 'C')
   and A.FAX01TIP = '9'
  
   
   
 <!--- FILTRO DE OFICINA--->
 <cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
  and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
 </cfif>
 
 <!--- FILTRO DE CLIENTE --->
 <cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
  and A.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
 </cfif>

</cfquery>
  

 	<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
	<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>


	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaAdelantosCliente.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
