#!/bin/bash
TOKEN1="eyJhbGciOiJSUzI1NiIsImtpZCI6IllQME5EdlNHRDFMSjh3TldONnVHeTFrcEFpcmYxX2RYZFFXMlAzaDJBcjQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRlZmF1bHQtdG9rZW4tbWNrdjUiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGVmYXVsdCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjdlNmYxODg0LTFiYzUtNDcyNC1iMmRmLTExNzUzYzBmOWI1MyIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmRlZmF1bHQifQ.C-CrF8heS0SxiGdVXCJBCGR5gDUbaLpvM2d4ba33w9w8JgxYVRb_fQsbMZ-HSWEJ9y7a4uHTztx-DgZSQKoaxDZ2iMsNAy_ez-F8XQWqbaTCHnxr4WLYf6c0A4AlVbbuTH6-OhP5bRQVvddTeFCi5Xzzomuf0x_N-NCwCuHjjH0Sb2wX70t5wKHPC_W0AF4QktjLXNgCmmpgGntcr6nhYE2WDXi1caj_JPA8-WRiOc5q-GOgTe9o6nf46pON0jIGbKWGt_UW4jwTShXqd3OJtOhrBN1ML92El3TBgiQMN-1pu2CJlq_eeqljWloXID9QUUVwEjy21oR0ouyGq1Us8g"
TOKEN2="eyJhbGciOiJSUzI1NiIsImtpZCI6IllQME5EdlNHRDFMSjh3TldONnVHeTFrcEFpcmYxX2RYZFFXMlAzaDJBcjQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImFkbWluLXRva2VuLXJoc3puIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMjI5NWQ3MTItODIzYi00ODBjLTg2YjItNzMzZGJlYzY2ODJkIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6YWRtaW4ifQ.N1tUA7RMZFWl7SUPtcOyLn3kZt0wsrUrkQmRz3OUACNjz4KR-KcFiE8UU3ZyR5_I2KT2CmF-yd4ShwmEKsWS_FpPoLly24mpdpmRzpuuqtsc0WPWupultB-xZcb7Rh9bedVKC0GIOBJfN0rduzy3cXCtmqtwEJR68npInId37sXBxRC_L3SGbcg-ShGPo4_0anOnv9pjF2ZRaPV6M3gEHUeWst3icEe5UZsU8fXREsho1xzMwUd1u7-n1w7SPGJr3E_m4V87BmRCvzr8CxMxwB1bwWUjPkL_XE2sQ4XPKscfnTddB7Jg3zo7kez1DXNND-vCzqr_iaoigzaI5FzzHQ"
TOKEN="eyJhbGciOiJSUzI1NiIsImtpZCI6IllQME5EdlNHRDFMSjh3TldONnVHeTFrcEFpcmYxX2RYZFFXMlAzaDJBcjQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImFwaS1leHBsb3Jlci10b2tlbi02NnNrNiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJhcGktZXhwbG9yZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJiYWRmOTc5Zi02ZjY3LTQzNWMtOGJkMi05MzNiZjI4ODRlZDIiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDphcGktZXhwbG9yZXIifQ.KeCr0RGXOVYXDhoOeUj9fnDSPW7CdUzhluB1mdX8zj2SeK0ABe4QUYaLEXfFEFtA75MDqK5EZ6h09pcahZOVdX7tb2ChvLJNMYVNNWg-M3Ynfl9POSqndkshseNHdgnq6glPOi-eQaH9ak9T5qc0dCIdUJvrlT0HvBv79kLAGe_d6GPIHmPBLho7NHNt1b9z_Wv0R7FnlIXDjL6stEQM--D5sHU-kViuMqujC67sLaO19hIL4gadnznS7CcHWmCAZ_E_om5EwNQmsW8wJpzDpcaPcfY7bTe-35s10DqKaZ_Z2-8kZfAOIVHkQhoqNvzjI8kwwCJiVQFBXIW6COW2sg"

curl -H "Authorization: Bearer $TOKEN" https://172.16.238.136:6443/api/v1/namespaces/default/pods  --insecure
