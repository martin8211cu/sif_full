<!--- Creado por: 	  Rebeca Corrales Alfaro  --->
<!--- Fecha: 		  25/05/2005  4:00 p.m. --->
<!--- Modificado por: --->
<!--- Fecha: 		  --->

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#session.DSN#">
select 
case A.FAX01TIP
	when '1' then 'FACT'	
	when '2' then 'RCxC'
	when '4' then 'DEV'
	when '9' then 'ADEL'
	when 'D' then 'RCxP'
end as tipoT,

 A.FAX01NTR as Transaccion,
 A.FAX01STA as Estado,
 H.Oficodigo as Oficina, 
 H.Odescripcion as Ofic_descrip,
 D.FAM01CODD as CodigoCaja, 
 C.FAX11DOC as Documento,
 A.FAX01FEC as FechaFactura,
 ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) as Cliente,
 coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
 A.FAX01TOT as TotalLinea,
 case when A.FAX01TPG = 1 then 'Crédito'
   else 'Contado'
 end as TipoPago,
 G.Miso4217 as CodigoMoneda
 from FAX001 as A
 


  left outer join FAX011 as C      /* No. de Documento */
  on    A.FAM01COD = C.FAM01COD
	and A.FAX01NTR = C.FAX01NTR
 	and A.Ecodigo = C.Ecodigo
 	and C.FAX11LIN = (select max(FAX11LIN) 
     from FAX011 doc 
  where doc.FAM01COD = C.FAM01COD 
    and doc.FAX01NTR = C.FAX01NTR 
    and doc.Ecodigo = C.Ecodigo )
 
  left outer  join FAM001 as D     /*cajas*/
  on    A.FAM01COD = D.FAM01COD
    and A.Ecodigo = D.Ecodigo
  
  left outer join ClientesDetallistasCorp as E /* clientes*/
  on    A.CDCcodigo = E.CDCcodigo
  
  inner join Monedas as G /*monedas */
  on    A.Mcodigo = G.Mcodigo
    and A.Ecodigo = G.Ecodigo
  
  inner join Oficinas as H /*Oficinas */
  on    A.Ocodigo = H.Ocodigo
    and A.Ecodigo = H.Ecodigo
	

 where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   <cfif isdefined("form.estado") and len(trim(form.estado))>
  and A.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="#form.estado#">
 </cfif> 
   

 
 <!--- FILTRO DE OFICINA --->
 <cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
  and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
 </cfif>
 <!--- FILTRO DE MONEDAS ---> 
  <cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
  	and A.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
  </cfif> 

 <!--- FILTRO DE TIPO TRANSACCION --->
 <cfif isdefined("form.FAX01TIP") and len(trim(form.FAX01TIP))>
  and A.FAX01TIP = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX01TIP#">
 </cfif>
 
</cfquery>
 
 	<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE REALIZARA EL REPORTE --->
	<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
		<cfset formatos = "excel">
	</cfif>


	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaTransTipo.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
		
</cfreport>
	