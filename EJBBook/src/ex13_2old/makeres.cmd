SETLOCAL
call ..\setEnv.cmd
java com.titan.clients.JmsClient_ReservationProducer %1 %2
ENDLOCAL
