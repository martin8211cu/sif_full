<!--- Ruta: cfusion-war\home\public --->
<!--- Link: http://166.148.6.213:9030/cfmx/home/public/FixMemBresias.cfm---> 

<!--- MEMBRESIAS --->
<!--- Busca todos los movimientos de membresia tipo postpagos  --->
<cfquery name="rsMembresias" datasource="minisif">
	select (coalesce(a.cantidadPositivos, 0) - coalesce(b.cantidadNegativos,0)) as montosCobradosdeMas,
	b.QPTPAN,
	b.QPTidTag
	from tmp_MemPos a
	right outer join tmp_MemNeg b
	on b.QPTidTag = a.QPTidTag
	<!--- where a.QPTidTag = 8 --->
</cfquery>


	<!--- <cf_dump var="#rsMembresias#"> --->

<cfsetting RequestTimeout = "18000">
<cfflush interval="16">
<cftransaction action="begin">

	<cfloop query="rsMembresias">

	    <cfset LvarTagCiclo = rsMembresias.QPTidTag> <!--- <cf_dump var="#LvarTagCiclo#"> --->
	    <cfoutput>tag #LvarTagCiclo#</cfoutput><br>	    

	    <!--- si tiene monto negativo inserta --->
	    <cfif rsMembresias.montosCobradosdeMas gt 0>

		<!--- busca los movimientos a borrar --->
	    	<cfquery name="rsMembresiasTop" datasource="minisif">
			select top #rsMembresias.montosCobradosdeMas#
			    mv.QPTidTag,
                	    mv.QPTPAN,
			    mv.QPMCid,
			    mv.QPMCdescripcion
              		  from QPventaTags vt
                 	   inner join QPMovCuenta mv
                 	    on mv.QPTidTag      = vt.QPTidTag
                 	   and mv.QPctaSaldosid = vt.QPctaSaldosid
                  	  and mv.QPcteid 		 = vt.QPcteid

                  	  inner join QPcuentaSaldos cs
               		     on cs.QPctaSaldosid = vt.QPctaSaldosid
               
             		  inner join QPCausa c
                    	     on c.QPCid = mv.QPCid
                	  where vt. Ecodigo = 2
                 	 and vt.QPvtaEstado = 1
                	  and cs.QPctaSaldosTipo = 1
                	  and c.QPCtipo = 3 
			  and mv.QPTidTag = #LvarTagCiclo# 
			  and mv.QPMCMonto > 0
			  
               		  and mv.QPMCFAfectacion is not null
               		  and mv.QPMCFAfectacion >= '20100302'
               		  and mv.QPMCFAfectacion <= '20100310 23:59:59'
			order by mv.QPMCid desc
		</cfquery>

	    	<cfloop query="rsMembresiasTop">
	      		<cfset LvarQPMCid = rsMembresiasTop.QPMCid>

              		<cfquery datasource="minisif">
            		  delete from QPMovCuenta 
			  where QPMCid = #LvarQPMCid#
			</cfquery>
	    	</cfloop>

	    </cfif>
	</cfloop>
	<cftransaction action="commit"/>
</cftransaction>

<cftransaction action="begin">
    <cfquery datasource="minisif">
        delete from QPMovCuenta
        where QPCid = 3
        and QPMCMonto = 0
        and QPMCFInclusion >= '20100301'
        and QPMCFInclusion <= '20100310 23:59:59'
    </cfquery>
	<cftransaction action="commit"/>	    
</cftransaction>
<cfoutput>FIN</cfoutput><br>