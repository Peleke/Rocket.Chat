import { useEffectEvent } from '@rocket.chat/fuselage-hooks';
import { Logger } from '@rocket.chat/logger';
import { useQuery, useQueryClient } from '@tanstack/react-query';

const logger = new Logger('MediaPermissions');

type MediaDevices = 'camera' | 'microphone';

const getDeviceKind = (name: MediaDevices): MediaDeviceKind => {
	switch (name) {
		case 'camera':
			return 'videoinput';
		case 'microphone':
			return 'audioinput';
	}
};

export const useMediaPermissions = (name: MediaDevices): [isPermissionDenied: boolean, setIsPermissionDenied: (state: boolean) => void] => {
	const queryClient = useQueryClient();

	const queryKey = ['media-permissions', name];

	const setIsPermissionDenied = useEffectEvent((isDenied: boolean) => {
		queryClient.setQueryData(queryKey, isDenied);
	});

	const { data } = useQuery({
		queryKey,
		queryFn: async () => {
			if (navigator.permissions) {
				try {
					const permissionStatus = await navigator.permissions.query({ name: name as PermissionName });
					permissionStatus.onchange = (): void => {
						queryClient.setQueryData(queryKey, permissionStatus.state === 'denied');
					};
					return permissionStatus.state === 'denied';
				} catch (error) {
					logger.warn(error);
				}
			}

			if (!navigator.mediaDevices?.enumerateDevices) {
				return true;
			}

			try {
				if (!(await navigator.mediaDevices.enumerateDevices()).some(({ kind }) => kind === getDeviceKind(name))) {
					return true;
				}
			} catch (error) {
				logger.warn(error);
			}
		},
		refetchOnMount: true,
		refetchOnWindowFocus: false,
		refetchOnReconnect: false,
		staleTime: Infinity,
		placeholderData: false,
	});

	return [Boolean(data), setIsPermissionDenied];
};
