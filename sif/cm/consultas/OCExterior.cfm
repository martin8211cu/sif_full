<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif url.formato eq 'pdf'>
<cfset tipo ='pdf'>
</cfif>
<cfif url.formato eq 'fla'>
<cfset tipo ='flashpaper'>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="rsReporte">
	select	Em.Edescripcion, 
		Dir.direccion1,
		Dir.codPostal,
		Emp.Etelefono1,
		Em.EIdentificacion as iden,
		Em.EDireccion1 as dir1,
		Em.EDireccion2 as dir2,
		Emp.Efax,
		EO.EOnumero, 
		EO.EOfecha,
		EO.EOtotal, 
		EO.EOplazo,
		SNC.SNCnombre,
		SNC.SNCfax,
		SNC.SNCtelefono,
		DO.DOconsecutivo,	
		case CMtipo 	when 'A' then ltrim(rtrim(f.Acodigo))#_Cat#'-'#_Cat#Adescripcion
       					when 'S' then ltrim(rtrim(h.Ccodigo ))#_Cat#'-'#_Cat#Cdescripcion
      					 when 'F' then ltrim(rtrim(k.ACcodigodesc))#_Cat#'-'#_Cat#j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as item,
		DO.Ucodigo,		
		DO.DOcantidad,
		#LvarOBJ_PrecioU.enSQL_AS("DO.DOpreciou")#,
		DO.DOtotal,		
		DO.DOfechareq,		
		Mo.Mnombre,
		Sn.SNidentificacion,
		Sn.SNnombre,
		Sn.SNtelefono,
		Sn.SNdireccion,
		Sn.SNcodigo,
		Sn.SNnumero,
		DSC.DSconsecutivo,
		DSC.ESnumero	 

	from	EOrdenCM EO
		
		inner join DOrdenCM DO
			on  EO.EOidorden  = DO.EOidorden

			<!---Articulos--->
			left outer join Articulos f
				on DO.Aid=f.Aid
				and DO.Ecodigo=f.Ecodigo
				and f.Ecodigo=EO.Ecodigo
      
			<!---Conceptos--->
			left outer join Conceptos h
				on DO.Cid=h.Cid
				and DO.Ecodigo=h.Ecodigo
				and h.Ecodigo=EO.Ecodigo
 
			<!---Activos--->
			left outer join ACategoria j
				on DO.ACcodigo=j.ACcodigo
				and DO.Ecodigo=j.Ecodigo
 
			left outer join AClasificacion k
				on DO.ACcodigo=k.ACcodigo
				and DO.ACid=k.ACid
				and DO.Ecodigo=k.Ecodigo
			
			left outer join DSolicitudCompraCM DSC
				on DO.Ecodigo = DSC.Ecodigo			
				and DO.DSlinea = DSC.DSlinea
 
		inner join Monedas Mo
			on  EO.Ecodigo = Mo.Ecodigo
			and EO.Mcodigo     = Mo.Mcodigo 
	
		inner join SNegocios Sn
			on EO.Ecodigo = Sn.Ecodigo
			and EO.SNcodigo = Sn.SNcodigo
			
			left outer join SNContactos SNC
				on Sn.SNcodigo = SNC.SNcodigo
				and Sn.Ecodigo = SNC.Ecodigo

		inner join Empresas Em
			on EO.Ecodigo = Em.Ecodigo
			
			inner join Empresa Emp
				on Em.EcodigoSDC=Emp.Ecodigo	
			
				inner join Direcciones Dir
					on Emp.id_direccion=Dir.id_direccion
								
    where 	EO.Ecodigo=#session.Ecodigo#
        and EO.EOnumero =#url.EOnumero#
    order by  EO.EOnumero,DO.DOconsecutivo
</cfquery>
<cfif rsReporte.iden  eq '815646-8'><!---815646-8 2PINOS    305-414-68335 D.V. 49  SOIN--->
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	    <cfset typeRep = 1>
		<cfif tipo EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cm.consultas.OCExterior_2pg"
			headers = "empresa:#session.Enombre#"/>
	<cfelse>
    <cfreport format="#tipo#" template="OCExterior_2pg.cfr" query="rsReporte">
     <cfreportparam name="Fecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#">   
       <cfreportparam name="Hora" value="#LSTimeFormat(now(),'hh:ss')#">  
       <cfreportparam name="enombre" value="#session.Enombre#">    
    </cfreport>
	</cfif>
<cfelse>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	    <cfset typeRep = 1>
		<cfif tipo EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cm.consultas.OCExterior"
			headers = "empresa:#session.Enombre#"/>
	<cfelse>
    <cfreport format="#tipo#" template="OCExterior.cfr" query="rsReporte">
     <cfreportparam name="Fecha" value="#LSDateFormat(now(),'dd/mm/yyyy')#">   
       <cfreportparam name="Hora" value="#LSTimeFormat(now(),'hh:ss')#">  
       <cfreportparam name="enombre" value="#session.Enombre#">    
    </cfreport>
	</cfif>
</cfif>

