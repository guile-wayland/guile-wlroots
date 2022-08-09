#define REF(A, B) (scm_c_public_ref(A, B))
#define FROM_P(P) (scm_from_pointer(P, NULL))
#define TO_P(P) (scm_to_pointer(P))
#define REF_CALL_1(M, N, ARG1) (scm_call_1(REF(M, N), ARG1))
#define REF_CALL_2(M, N, ARG1, ARG2) (scm_call_2(REF(M, N), ARG1, ARG2))
#define REF_CALL_3(M, N, ARG1, ARG2 ,ARG3) (scm_call_3(REF(M, N), ARG1, ARG2,ARG3))
#define SCM_LOOKUP_REF(name)    (scm_variable_ref(scm_c_lookup(name)))
#define WRAP_WLR_BACKEND(p) (REF_CALL_1("wlroots backend", "wrap-wlr-backend",FROM_P(p)))
#define UNWRAP_WLR_BACKEND(p) (TO_P(REF_CALL_1("wlroots backend", "unwrap-wlr-backend",p)))
