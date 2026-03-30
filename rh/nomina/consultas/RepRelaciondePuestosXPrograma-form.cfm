<!---<cf_dump var="#form#">--->

<cfquery name="rsTablaVigente" datasource="#session.DSN#">
select max(RHVTid) as RHVTid
	from RHVigenciasTabla 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and RHVTestado = 'A'
	and  getdate() between RHVTfecharige and RHVTfechahasta  	
</cfquery>	

<cfquery name="rsResumenPuestos" datasource="#session.DSN#">
	  select
	  		Ofc.Odescripcion   
	      ,cat.RHCcodigo 			
	      ,puestos.RHPcodigo
	      ,puestos.RHPdescpuesto		  
	      ,sum (LT.LTporcplaza/100 ) as tiemposCompl 
	      ,count( plz.RHPid) as cantPlz	 
	     ,montCateg.RHMCmontoAnt as baseActual	
 	     ,montCateg.RHMCmonto  as basePropuesta	   
         ,(montCateg.RHMCmonto *  sum (LT.LTporcplaza/100 )  * 12) as totalAnual 
	 
  from   RHSituacionActual SituacAct

	inner join RHPlazaPresupuestaria plzPresup
		on plzPresup.RHPPid = SituacAct.RHPPid
		and   plzPresup.Ecodigo  =SituacAct.Ecodigo 

	inner join RHMaestroPuestoP maest
		on maest.RHMPPid = plzPresup.RHMPPid
		and maest.Ecodigo = plzPresup.Ecodigo

	inner join RHCategoriasPuesto catPuesto
		on catPuesto.RHMPPid = maest.RHMPPid
		and catPuesto.Ecodigo = maest.Ecodigo

	inner join RHPlazas plz
		on  plz.RHPPid = plzPresup.RHPPid 
		and plz.Ecodigo = plzPresup.Ecodigo	
		
			inner join CFuncional Cfunc
				on Cfunc.CFid= plz.CFid
				and Cfunc.Ecodigo = plz.Ecodigo 

				inner join Oficinas Ofc
					on Ofc.Ocodigo = Cfunc.Ocodigo
					and Ofc.Ecodigo = Cfunc.Ecodigo
					<cfif isdefined('form.Ocodigo') and len(rtrim(form.Ocodigo))>
						and Ofc.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					</cfif>
				
	inner join LineaTiempo LT
		on LT.RHPid = plz.RHPid
		and LT.Ecodigo = plz.Ecodigo 
		and getdate() between LT.LTdesde and  LT.LThasta 

	inner join RHPuestos puestos
		on  puestos.RHPcodigo = plz.RHPpuesto
		and puestos.Ecodigo = plz.Ecodigo       
	
	inner join RHCategoria cat
		on cat.RHCid = catPuesto.RHCid
		and cat.Ecodigo = catPuesto.Ecodigo 

	inner join RHMontosCategoria montCateg
		on montCateg.RHCid = cat.RHCid 
		and montCateg.RHVTid = #rsTablaVigente.RHVTid#  

  where  SituacAct.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" >
  and SituacAct.RHEid = #form.RHEid# 
	
group by Ofc.Odescripcion,cat.RHCcodigo,puestos.RHPdescpuesto,puestos.RHPcodigo  ,montCateg.RHMCmonto ,montCateg.RHMCmontoAnt 	
order by  Ofc.Odescripcion,cat.RHCcodigo ,puestos.RHPdescpuesto, puestos.RHPcodigo ,montCateg.RHMCmonto ,montCateg.RHMCmontoAnt 

</cfquery>

<cfquery name="rsResumOtrosIncent" datasource="#session.DSN#">
	select CSdescripcion,sum(Monto) as monto
	from RHSituacionActual a
	
	inner join RHPlazaPresupuestaria plzPresup
		on plzPresup.RHPPid = a.RHPPid
		and plzPresup.Ecodigo =a.Ecodigo 

	inner join RHPlazas plz
		on  plz.RHPPid = plzPresup.RHPPid 
		and plz.Ecodigo = plzPresup.Ecodigo	

	inner join CFuncional Cfunc
		on Cfunc.CFid= plz.CFid
		and Cfunc.Ecodigo = plz.Ecodigo 

        inner join Oficinas Ofc
		on Ofc.Ocodigo = Cfunc.Ocodigo
		and Ofc.Ecodigo = Cfunc.Ecodigo
		
		<cfif isdefined('form.Ocodigo') and len(rtrim(form.Ocodigo))>
			and Ofc.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
		</cfif>
	
	inner join RHCSituacionActual b
		on b.RHSAid = a.RHSAid
	inner join ComponentesSalariales c
		on c.CSid = b.CSid
	
	where RHEid = #form.RHEid# 
	  and CSsalariobase =0
	group by b.CSid, CSdescripcion

</cfquery>


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="RepRelaciondePuestosXPrograma-rep.cfm">