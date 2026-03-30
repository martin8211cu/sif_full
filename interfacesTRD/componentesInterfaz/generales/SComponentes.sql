insert aspser..SComponentes 
(SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
values ('SIF', 'INTERPMI', 'OTROSINGR', '/interfacesTRD/componentesInterfaz/otrosingresos/index.cfm', 'P', 0, '20070312', 0)

update aspser..SProcesos
set SPhomeuri = '/interfacesTRD/componentesInterfaz/otrosingresos/index.cfm'
where SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'OTROSINGR'
